import 'package:assistance_flutter/services/persistent_storage_service.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';


class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> login(int dni, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = PreferencesUser(); 

      final Map<String,dynamic>body={
        "dni":dni,
        "password":password
      };
      final response = await _authService.login(body);

      print("🚀 ~ AuthProvider ~ Future<void>login ~ response:"+response);

      
      if (response.statusCode == 200) {
        
        
      } else {
         _errorMessage = 'Usuario o contraseña incorrectos';
      }
    } catch (error) {
      _errorMessage = 'Error en la conexión';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}