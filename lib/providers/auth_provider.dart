import 'dart:developer';

import 'package:assistance_flutter/models/user_model.dart';
import 'package:assistance_flutter/services/device.service.dart';
import 'package:assistance_flutter/services/persistent_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final deviceService = DeviceService();
  final localAuthentication = LocalAuthentication();

  bool _isLoading = false;
  bool _isLoadingFingerprint = false;
  String? _errorMessage;
  late UserModel user;

  bool get isLoading => _isLoading;
  bool get isLoadingFingerprint => _isLoadingFingerprint;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String dni, String password) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final prefs = PreferencesUser();
      final device = await deviceService.getAndroidId();
      final Map<String, dynamic> body = {
        "dni": int.parse(dni),
        "password": password,
        ...device
      };
      log(
        "🚀 ~ AuthProvider ~ Future<bool>login ~ body: $body",
      );
      final response = await _authService.login(body);

      //debugPrint("🚀 ~ AuthProvider ~ Future<void>login ~ response:"+response);

      if (response["status"]) {
        prefs.user = response['data'];
        prefs.token = response['token'];
        prefs.userAuth = {
          "dni": int.parse(dni),
          "password": password,
        };
        this.user = UserModel.fromJsonMap(prefs.user);
        return true;
      } else {
        _errorMessage = 'Usuario o contraseña incorrectos';
        return false;
      }
    } catch (error) {
      _errorMessage = 'Error en la conexión';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> authenticateWithFingerprint() async {

    try {


      bool isAuthenticated = await localAuthentication.authenticate(
        localizedReason: 'Please authenticate to access this feature',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      _isLoadingFingerprint = true;
      notifyListeners();
      log("🚀 ~ AuthProvider ~ Future<bool>login $isAuthenticated",);
      await Future.delayed(Duration(seconds: 5));
      _isLoadingFingerprint = false;
      notifyListeners();
      return true;
     
    } catch (e) {
      print(e);
      return false;
      
    }finally {
      _isLoading = false;
      notifyListeners();
    }

  }
}
