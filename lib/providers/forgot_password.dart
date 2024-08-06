
import 'dart:developer';

import 'package:assistance_flutter/helper/message_error.dart';
import 'package:assistance_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';

class ForgotPasswordProvider with ChangeNotifier {

  final AuthService _authService = AuthService();

 bool _isLoadingForgotPassword = false;
 bool _isLoadingValidatePhone = false;
 bool _isLoadingValidateUser = false;
  
  // Estado de visibilidad para las contraseñas
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
   String _errorMessage = '';
   String _errorMessagePhone = '';
   String _errorMessagechangePassword = '';
   String _selectedPhone='';

  // Getter para la visibilidad de la contraseña
  bool get isLoadingForgotPassword => _isLoadingForgotPassword;
  bool get isLoadingValidateUser => _isLoadingValidateUser;
  bool get isLoadingValidatePhone => _isLoadingValidatePhone;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  String get errorMessage => _errorMessage;
  String get errorMessagePhone => _errorMessagePhone;
  String get errorMessagechangePassword => _errorMessagechangePassword;
  String get selectedPhone => _selectedPhone;

  late Map<String,dynamic> data;
  
 


  Future<List<dynamic>> validateUser(String dni,String email) async{
    try {

      _isLoadingValidateUser=true;
      notifyListeners();


      Map<String, dynamic> body={
        "dni": int.parse(dni),
        "email":email
      };

      final response = await _authService.validateUser(body);
      if(response.containsKey('status')  && response['status']){
        data=body;
        
        return response['data'];
      }else{
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
        notifyListeners();
     
        return [];
      }

     
    } catch (e) {
      log("Error: $e");
      _errorMessage = MessageError.handleError('MESSAGE_DEFAULT');
      return [];
    } finally {
      _isLoadingValidateUser = false;
      notifyListeners();
    }
  }


  Future<bool> validatePhone() async{
    try {

      _isLoadingValidatePhone=true;
      notifyListeners();

      if(_selectedPhone.isEmpty){
        _isLoadingValidatePhone=false;
        _errorMessagePhone = 'Por favor, selecciona un número de teléfono. 📞🔢 Es necesario para completar el proceso.';
        return false;
      }

      Map<String, dynamic> body={
        "dni": data["dni"],
        "email":data['email'],
        "phone": int.parse(_selectedPhone)
      };

      final response = await _authService.validatePhone(body);
      if(response.containsKey('status')  && response['status']){
        data['hash']=response['data']['hash'];
        
        return true;
      }else{
        if(response.containsKey('message') && response['message'] is List){

          List<dynamic> messageArray = response['message'];

          if(messageArray.isNotEmpty){
             _errorMessagePhone = MessageError.handleError(messageArray[0]);
          }else{
             _errorMessagePhone = MessageError.handleError(response['message']);
          }
          
        }else{
          _errorMessagePhone = MessageError.handleError(response['message']);
        }
        notifyListeners();
     
        return false;
      }

     
    } catch (e) {
      log("Error: $e");
      _errorMessagePhone = MessageError.handleError('MESSAGE_DEFAULT');
      return false;
    } finally {
      _isLoadingValidatePhone = false;
      notifyListeners();
    }
  }


  Future<bool> changePassword(String password,String confirmPassword) async{
    try {

      _isLoadingForgotPassword=true;
      notifyListeners();

      if(password.isEmpty || confirmPassword.isEmpty){
        _isLoadingForgotPassword=false;
        _errorMessagechangePassword = 'Las contraseñas no pueden estar vacías. 🔒✏️ Por favor, asegúrate de ingresar una contraseña en ambos campos.';
        return false;
      }

      Map<String, dynamic> body={
        "dni": data["dni"],
        "hash":data['hash'],
        "password":password,
        "confirm_password":confirmPassword
      };

      final response = await _authService.changePassword(body);
      if(response.containsKey('status')  && response['status']){
        
        return true;
      }else{
        if(response.containsKey('message') && response['message'] is List){

          List<dynamic> messageArray = response['message'];

          if(messageArray.isNotEmpty){
             _errorMessagechangePassword = MessageError.handleError(messageArray[0]);
          }else{
             _errorMessagechangePassword = MessageError.handleError(response['message']);
          }
          
        }else{
          _errorMessagechangePassword = MessageError.handleError(response['message']);
        }
        notifyListeners();
     
        return false;
      }

     
    } catch (e) {
      log("Error: $e");
      _errorMessagechangePassword = MessageError.handleError('MESSAGE_DEFAULT');
      return false;
    } finally {
      _isLoadingForgotPassword = false;
      notifyListeners();
    }
  }



  // Método para alternar la visibilidad de la contraseña
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // Método para alternar la visibilidad de la confirmación de contraseña
  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  void selectPhone(String phone) {
    _selectedPhone = phone;
    notifyListeners();
  }
}