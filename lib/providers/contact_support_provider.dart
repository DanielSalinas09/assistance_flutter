



import 'package:assistance_flutter/services/contact_support.service.dart';
import 'package:flutter/material.dart';

class ContactSupportProvider with ChangeNotifier {

  final contactSupportService= new ContactSupportService();

   bool _isLoading = false;
   String? _message;


   bool get isLoading => _isLoading;
   String? get message => _message;

  Future<bool> createSupport(String message,String student_id)async{
    try {
      _isLoading=true;

      notifyListeners();

      Map<String,dynamic> data={
        "student_id":student_id,
        "message":message,
      };

      final response = await contactSupportService.create(data);
      if(response['status']){
        message='La informacion fue enviada correctamente.';
        return true;
        
      }else{
        message='Ocurrió un error al enviar la información. 📤 Por favor, intenta nuevamente.';
        return false;
      }
      
    } catch (e) {
       message='Ocurrió un error al enviar la información. 📤 Por favor, intenta nuevamente.';
      _isLoading=false;
      return false;
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
