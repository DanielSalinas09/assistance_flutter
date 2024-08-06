


class MessageError{


  static String handleError(String message) {
    String response='';
    switch (message) {
      case 'STUDENT_NOT_FOUND':
        response = "¡Lo sentimos! 😕 No pudimos encontrar al estudiante solicitado. Por favor, verifica el DNI e inténtalo de nuevo.";
        break;
      case 'INVALID_PASSWORD':
        response = "La contraseña ingresada no es correcta. 🔑 Por favor, verifica y vuelve a intentarlo.";
        break;
      case 'EMAIL_MISMATCH':
        response = "¡Ups! 📧 El correo electrónico proporcionado no coincide con nuestros registros. Por favor, verifica e inténtalo nuevamente.";
        break;
      case 'INVALID_PHONE_NUMBER':
        response = "📱 El número de teléfono ingresado no es válido. Por favor, verifica e inténtalo de nuevo.";
        break;
      case 'HASH_NOT_MATCH':
        response = "🔒 La verificación ha fallado. El código de seguridad no coincide. Por favor, inténtalo nuevamente.";
        break;
      case 'PASSWORDS_NOT_MATCH':
        response = "🔑 Las contraseñas no coinciden. Por favor, verifica e inténtalo de nuevo.";
        break;
      
      case 'PASSWORD_ALREADY_USED':
        response = "🔒 La contraseña que has ingresado ya ha sido utilizada anteriormente. Por favor, elige una nueva contraseña.";
        break;

      case 'PASSWORD_CHANGE_FAILED':
        response = "⚠️ No se pudo cambiar la contraseña. Por favor, intenta nuevamente más tarde.";
        break;
      
      case 'DEVICE_ALREADY_IN_USE_BY_STUDENT':
        response = "¡Atención! 🚫 Otro estudiante ya ha iniciado sesión en este dispositivo. Debes esperar dos horas antes de intentar iniciar sesión nuevamente.";
        break;
      
      case 'DEVICE_ASSOCIATION_FAILED':
        response = "¡Lo sentimos! 😕 No pudimos asociar el dispositivo al estudiante. Por favor, intenta nuevamente.";
        break;

      case 'El usuario proporcionado es incorrecto.':
        response = "¡Lo sentimos! 😕 No pudimos encontrar al estudiante solicitado. Por favor, verifica el DNI e inténtalo de nuevo.";
        break;


      
      


      case 'MESSAGE_DEFAULT':
        response = "¡Lo sentimos! 😕 No pudimos encontrar al estudiante solicitado. Por favor, verifica el DNI e inténtalo de nuevo.";
        break;


      default:
      response = message.isNotEmpty?message:'¡Oh, no! 😔 Algo salió mal de manera inesperada. Por favor, vuelve a intentarlo en unos momentos.';
    }

    return response;
  }
}