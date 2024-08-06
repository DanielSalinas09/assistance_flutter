import 'dart:developer';

import 'package:assistance_flutter/helper/exception.dart';
import 'package:assistance_flutter/helper/message_error.dart';
import 'package:assistance_flutter/models/user_model.dart';
import 'package:assistance_flutter/services/device.service.dart';
import 'package:assistance_flutter/services/persistent_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {

  final AuthService _authService = AuthService();
  final deviceService = DeviceService();
  final localAuth = LocalAuthentication();
  final prefs = PreferencesUser();

  bool _isLoading = false;
  bool _isLoadingAuthenticated = false;
  bool _isLoadingFingerprint = false;
  bool _visibilityPassword = true;

  String _errorMessage = '';

  late UserModel user;

  bool get isLoading => _isLoading;
  bool get isLoadingFingerprint => _isLoadingFingerprint;
  bool get isLoadingAuthenticated => _isLoadingAuthenticated;
  bool get visibilityPassword => _visibilityPassword;
  String get errorMessage => _errorMessage;


  Future<bool> login(String dni, String password) async {

    _isLoading = true;
    _errorMessage = '';

    notifyListeners();

    try {
      
      final device = await deviceService.getAndroidId();
      final Map<String, dynamic> body = {
        "dni": int.parse(dni),
        "password": password,
        ...device
      };
      
      final response = await _authService.login(body);
      
      //debugPrint("🚀 ~ AuthProvider ~ Future<void>login ~ response:"+response);

      if (response["status"]) {
        prefs.user = response['data'];
        prefs.token = response['token'];
        prefs.userAuth = {
          "dni": int.parse(dni),
          "password": password,
        };
       
        user = UserModel.fromJsonMap(prefs.user);
        return true;
      } else {
        if(response.containsKey('message') && response['message'] is List){

          List<dynamic> messageArray = response['message'];

          if(messageArray.isNotEmpty){
             _errorMessage = MessageError.handleError(messageArray[0]);
          }else{
             _errorMessage = MessageError.handleError(response['message']);
          }
          
        }else{
          _errorMessage = MessageError.handleError(response['message']);
        }
        return false;
      }
    } on AppException catch(err){
      log("🚀 ~ AuthProvider ~ Future<bool>login ~ err: $err");
      _errorMessage = MessageError.handleError('MESSAGE_DEFAULT');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<bool> authenticateWithFingerprint() async {
    try {
      final bool authBiometrics = await localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          authBiometrics || await localAuth.isDeviceSupported();
       
      if (!canAuthenticate) {
        _isLoadingFingerprint = false;
        _errorMessage = "No se puede autenticar con la huella dactilar en este momento. 🖐️🔒 revisa la configuración de tu dispositivo.";
        notifyListeners();
        return false;
      }

      bool isAuthenticated = await localAuth.authenticate(
        localizedReason: 'Por favor autentíquese para poder iniciar sesiòn',
        options: const AuthenticationOptions(
          useErrorDialogs: false,
          stickyAuth: true,
        ),
      );

      if (!isAuthenticated) {
        _isLoadingFingerprint = false;
        _errorMessage = "La huella dactilar no coincide. 🚫🖐️ Por favor, asegúrate de que el sensor esté limpio y vuelve a intentarlo.";
        notifyListeners();
        return false;
      }
      _isLoadingFingerprint = true;
      notifyListeners();

      
      final device = await deviceService.getAndroidId();
      final Map<String, dynamic> body = {
        "dni": int.parse(prefs.userAuth['dni']),
        "password": prefs.userAuth['password'],
        ...device
      };
      log("🚀 ~ AuthProvider ~ Future<bool>login ~ body: $body");
      final response = await _authService.login(body);

      if (response["status"]) {

        prefs.user = response['data'];
        prefs.token = response['token'];
        prefs.userAuth = {
          "dni": int.parse(prefs.userAuth['dni']),
          "password": prefs.userAuth['password'],
        };

        this.user = UserModel.fromJsonMap(prefs.user);
        _isLoadingFingerprint = false;
        return true;
      } else {
        if(response.containsKey('message') && response['message'] is List){

          List<dynamic> messageArray = response['message'];

          if(messageArray.isNotEmpty){
             _errorMessage = MessageError.handleError(messageArray[0]);
          }else{
             _errorMessage = MessageError.handleError(response['message']);
          }
          
        }else{
          _errorMessage = MessageError.handleError(response['message']);
        }
        _isLoadingFingerprint = false;
        return false;
      }
      
    } catch (e) {
      print(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<bool> canUseFingerprintLogin() async {

     final bool authBiometrics = await localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          authBiometrics || await localAuth.isDeviceSupported();

    if(prefs.userAuth.isEmpty || !prefs.fingerPrint){
        prefs.fingerPrint=true;
       _errorMessage = '👋 ¡Hola! Por favor, ingresa con tu usuario y contraseña la primera vez. Después, podrás iniciar sesión con tu huella digital. 📲';
       notifyListeners();
      return false;
    }

    if(canAuthenticate){
       prefs.fingerPrint=true;
       _errorMessage = '🚫 Lo sentimos, este dispositivo no está habilitado para iniciar sesión con huella digital.';
       notifyListeners();
      return false;
    }
    return true;
    
  }


  Future<bool>checkUserSession() async {

    try {

      _isLoadingAuthenticated=true;

      final response = await _authService.checkUserSession();
      log("🚀 ~ checkUserSession ~ $response");
      if(response['status']){
         prefs.user = response['data'];
  
        return true;
      }else{
        return false;
      }
        
    } catch (e) {
      return false;
    }finally {
      _isLoadingAuthenticated=false;

      notifyListeners();
    }

  }

  void toggleVisibility() {
    _visibilityPassword = !_visibilityPassword;
    notifyListeners();
  }

  bool isFingerprintEnabled()  {
    return prefs.fingerPrint;
  }
}

