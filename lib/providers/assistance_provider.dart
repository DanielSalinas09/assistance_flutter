import 'package:assistance_flutter/models/user_model.dart';
import 'package:assistance_flutter/services/assistance.service.dart';
import 'package:flutter/material.dart';


class AssistanceProvider with ChangeNotifier {

  final AssistanceService _assistanceService = AssistanceService();

  bool _isLoading = false;
  String? _errorMessage;


  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> takeAssistance(Map<String,dynamic>body) async {

    if (_isLoading) {
      // Si ya está cargando, evita hacer otra solicitud
      return false;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      
      
      final response = await _assistanceService.takeAsistance(body);
      
      if (response["status"]) {
        return true;
      } else {
       
         _errorMessage = 'Ocurrio un error al registrar la asistencia';
         return false;
      }
    } catch (error) {
    
      _errorMessage = 'Ocurrio un error, por favor intente nuevamente';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}