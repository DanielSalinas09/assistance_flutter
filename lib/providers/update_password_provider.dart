import 'package:assistance_flutter/helper/message_error.dart';
import 'package:assistance_flutter/services/update_password.service.dart';
import 'package:flutter/material.dart';

class UpdatePasswordProvider with ChangeNotifier {
  final updatePasswordService = new UpdatePasswordService();

  bool _isLoading = false;
  late String _message;

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  bool get isLoading => _isLoading;
  String get message => _message;
  bool get obscureCurrentPassword => _obscureCurrentPassword;
  bool get obscureNewPassword => _obscureNewPassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  Future<bool> updatePassword(
      String password, String newPassword, String confirmPassword) async {
    try {
      _isLoading = true;

      notifyListeners();

      Map<String, dynamic> data = {
        "password": password,
        "new_password": newPassword,
        "confirm_password": newPassword,
      };

      final response = await updatePasswordService.updatePassword(data);
      if (response.containsKey('status') &&response['status']) {
        _message = 'La informacion fue enviada correctamente.';
        return true;
      } else {
        if (response.containsKey('message') && response['message'] is List) {
          List<dynamic> messageArray = response['message'];

          if (messageArray.isNotEmpty) {
            _message = MessageError.handleError(messageArray[0]);
          } else {
            _message = MessageError.handleError(response['message']);
          }
        } else {
          _message = MessageError.handleError(response['message']);
        }
        notifyListeners();

        return false;
      }
    } catch (e) {
      _message =  MessageError.handleError('Ocurrió un error al enviar la información. 📤 Por favor, intenta nuevamente.');
      _isLoading = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleObscureCurrentPassword() {
    _obscureCurrentPassword = !_obscureCurrentPassword;
    notifyListeners();
  }

  void toggleObscureNewPassword() {
    _obscureNewPassword = !_obscureNewPassword;
    notifyListeners();
  }

  void toggleObscureConfirmPassword() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }
}
