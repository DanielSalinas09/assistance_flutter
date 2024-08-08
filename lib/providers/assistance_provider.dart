import 'package:assistance_flutter/services/assistance.service.dart';
import 'package:flutter/material.dart';

class AssistanceProvider with ChangeNotifier {
  final AssistanceService _assistanceService = AssistanceService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<AssistanceResult> takeAssistance(Map<String, dynamic> body) async {
    if (_isLoading) {
      // Si ya está cargando, evita hacer otra solicitud
      return AssistanceResult(
        status: false,
        message: "peticion cargando",
      );
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();
    Map<String,dynamic> response = {};
    try {
      response = await _assistanceService.takeAsistance(body);

      if (response["status"]) {
        return AssistanceResult(
          status: true,
          message: "done",
        );
      } else {
        _errorMessage = 'Ocurrio un error al registrar la asistencia';
        return AssistanceResult(
          status: false,
          message: "peticion cargando",
        );
      }
    } catch (error) {

      if (response['message'] == 'Estudiante ya asistió') {
        print("entramos aca");
        return AssistanceResult(
          status: false,
          message: "Estudiante ya asistió",
        );
      }
      _errorMessage = 'Ocurrio un error, por favor intente nuevamente';
      return AssistanceResult(
        status: false,
        message: _errorMessage!,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class AssistanceResult {
  final bool status;
  final String message;

  AssistanceResult({required this.status, required this.message});
}
