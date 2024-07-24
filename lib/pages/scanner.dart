import 'dart:io';

import 'package:assistance_flutter/providers/assistance_provider.dart';
import 'package:assistance_flutter/providers/auth_provider.dart';
import 'package:assistance_flutter/services/assistance.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

 class _ScannerPageState extends State<ScannerPage> {

 final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String? code;

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
        title: Text('Scanner QR'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
        
        body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10
                ),
            ),
          ),
          
        ],
      ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(()async {
        
        
        if(scanData.code!.isNotEmpty){

          final assistanceProvider = Provider.of<AssistanceProvider>(context, listen: false);
          final authProvider = Provider.of<AuthProvider>(context, listen: false);

          final Map<String, dynamic> body ={
          "courseId": scanData.code,
          "studentId": authProvider.user.id

        };
          final response= await assistanceProvider.takeAssistance(body);
          if(response){
            this._showMyDialogSuccess();
          }else{
            this._showMyDialogError();
          }
          
        }

      });
    });
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
              Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
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