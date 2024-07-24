import 'dart:developer';
import 'dart:io';

import 'package:assistance_flutter/services/assistance.service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      setState(() {
        final assistanceService = AssistanceService();
        final Map<String, dynamic> body ={
          "courseId": scanData.code,
          "studentId": "669356ac7fed0b6dc4ec5296"

        };
        if(scanData.code!.isNotEmpty){
          this._showMyDialog();
        }
        //assistanceService.takeAsistance();
        print(scanData!.code);
        print(scanData.format);
      });
    });
  }

  Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
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