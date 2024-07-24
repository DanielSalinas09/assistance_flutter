import 'package:assistance_flutter/models/user_model.dart';
import 'package:assistance_flutter/services/persistent_storage_service.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';


class AuthProvider with ChangeNotifier {

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  late UserModel user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String dni, String password) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final prefs = PreferencesUser(); 
      
      final Map<String,dynamic>body={
        "dni":int.parse(dni),
        "password":password
      };
      final response = await _authService.login(body);

      //debugPrint("🚀 ~ AuthProvider ~ Future<void>login ~ response:"+response);

      
      if (response["status"]) {
        prefs.user=response['data'];
        prefs.token=response['token'];
        this.user=UserModel.fromJsonMap(prefs.user);
        return true;
      } else {
        // Handle login error
         _errorMessage = 'Usuario o contraseña incorrectos';
         return false;
      }
    } catch (error) {
      // Handle request error
      _errorMessage = 'Error en la conexión';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}