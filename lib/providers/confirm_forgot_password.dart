
import 'package:flutter/material.dart';

class ConfirmForgotPasswordProvider with ChangeNotifier {
  // Estado de visibilidad para las contraseñas
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Getter para la visibilidad de la contraseña
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

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
}