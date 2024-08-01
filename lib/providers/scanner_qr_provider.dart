

import 'package:flutter/material.dart';

class ScannerQrProvider with ChangeNotifier {


  bool _isScanning = false;
  String? _errorMessage;


  bool get isScanning => _isScanning;
  String? get errorMessage => _errorMessage;

  // Future<bool> scanningQR(Map<String,dynamic>body) async {
  //   _isScanning = true;
  //   _errorMessage = null;

  //   notifyListeners();

  //   // try {
      
      
  //   //   final response = await _assistanceService.takeAsistance(body);
      
  //   //   if (response["status"]) {
  //   //     return true;
  //   //   } else {
       
  //   //      _errorMessage = 'Ocurrio un error al registrar la asistencia';
  //   //      return false;
  //   //   }
  //   // } catch (error) {
    
  //   //   _errorMessage = 'Ocurrio un error, por favor intente nuevamente';
  //   //   return false;
  //   // } finally {
  //   //   _isLoading = false;
  //   //   notifyListeners();
  //   // }
  // }
}