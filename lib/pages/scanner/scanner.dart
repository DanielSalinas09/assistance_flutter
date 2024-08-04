import 'dart:io';

import 'package:assistance_flutter/providers/assistance_provider.dart';
import 'package:assistance_flutter/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
   bool flashOn = false;
  double zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      print('Permiso de cámara concedido');
    } else if (status.isDenied) {
      print('Permiso de cámara denegado');
      _requestCameraPermission();
    } else if (status.isPermanentlyDenied) {
      print('Permiso de cámara permanentemente denegado');
      // Puedes redirigir al usuario a la configuración para que active el permiso manualmente
      openAppSettings();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Scanner QR'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body:  Stack(
        children: [
          QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay:
              QrScannerOverlayShape(borderColor: Colors.red, borderRadius: 10),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
        Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    flashOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    if (controller != null) {
                      await controller!.toggleFlash();
                      setState(() {
                        flashOn = !flashOn;
                      });
                    }
                  },
                ),
                
              ],
            ),
          ),
        ])
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code!.isNotEmpty) {
        final assistanceProvider =
            Provider.of<AssistanceProvider>(context, listen: false);
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        final Map<String, dynamic> body = {
          "courseId": scanData.code,
          "studentId": authProvider.user.id
        };

        if (!assistanceProvider.isLoading) {
          final response = await assistanceProvider.takeAssistance(body);
          if (response) {
            _showMyDialogSuccess();
          } else {
            _showMyDialogError();
          }
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Future<void> _showMyDialogSuccess() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('¡Bien hecho!')),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Su asistencia a sido registrada correctamente'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogError() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('¡Ha ocurrido un error!')),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Ha ocurrido un error, por favor intente nuevamente.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
