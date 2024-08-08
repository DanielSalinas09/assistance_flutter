import 'dart:async';
import 'dart:io';

import 'package:assistance_flutter/providers/assistance_provider.dart';
import 'package:assistance_flutter/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with WidgetsBindingObserver {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  double zoomLevel = 1.0;
  bool isloading = false;
  bool isTakeAssitance = false;
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
    formats: [BarcodeFormat.qrCode],
  );
  double _zoomFactor = 0.0;
  StreamSubscription<Object?>? _subscription;
  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = controller.barcodes.listen(_handleBarcode);

    // Finally, start the scanner itself.
    unawaited(controller.start());

    _requestCameraPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
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
  }

  Widget _buildZoomScaleSlider() {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        final TextStyle labelStyle = Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.white, fontSize: 18);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '0%',
                overflow: TextOverflow.fade,
                style: labelStyle,
              ),
              Slider(
                value: _zoomFactor,
                activeColor: Colors.red,
                onChanged: (value) {
                  controller.setZoomScale(_zoomFactor);
                  setState(() {
                    _zoomFactor = value;
                  });
                },
              ),
              Text(
                '100%',
                overflow: TextOverflow.fade,
                style: labelStyle,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    return  Scaffold(
          appBar: AppBar(
            title: const Text('Scanner QR'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Stack(children: [
            MobileScanner(
              controller: controller,
              fit: BoxFit.cover,
            ),
            Center(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.red, width: 2.0),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: ClipPath(
                clipper: QRClipper(),
                child: Container(
                  color: Colors.black54, // semi-transparent black overlay
                ),
              ),
            ),
            Positioned(
                bottom: 0.0,
                left: sizeScreen.width * 0.15,
                child: _buildZoomScaleSlider())
          ]));
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
                this.isTakeAssitance = false;
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
                Text('Este estudiante ya ha registrado su asistencia.'),
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

  @override
  Future<void> dispose() async {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _subscription = null;
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    await controller.dispose();
  }

  void _handleBarcode(BarcodeCapture qr) async {
    final assistanceProvider =
        Provider.of<AssistanceProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final Map<String, dynamic> body = {
      "secret": qr.barcodes[0].rawValue,
      "studentId": authProvider.user.id
    };

    if (!assistanceProvider.isLoading) {
      final response = await assistanceProvider.takeAssistance(body);
      if (response.status) {
        isTakeAssitance = true;
        _showMyDialogSuccess();
      }else{
        print("response ${response.message}");
        if (response.message == 'Estudiante ya asistió') {
          if(!assistanceProvider.isLoading && !isTakeAssitance){
            _showMyDialogError();
          }
        }
        print("response $response");
      }
    }
  }
}

class QRClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = 220;
    double height = 220;
    double left = (size.width - width) / 2;
    double top = (size.height - height) / 2;

    Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(Rect.fromLTWH(left, top, width, height));

    return path..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
