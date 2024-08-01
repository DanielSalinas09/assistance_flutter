


import 'dart:convert';

import 'package:assistance_flutter/services/http_service.dart';


class AuthService {

  final httpService=HttpService();
  

  Future<Map<String,dynamic>> login(Map<String, dynamic> body) async {
    try {
      
      final response =await this.httpService.postRequest('auth/login/student', body);

      final decodeResponse = json.decode(response.body);
      return decodeResponse;
     }catch(e){
      print('Error: $e');
      final error = json.decode(e.toString());
       print('Error2: $error');
      return {"status":false,"error":e.toString()};
     }
  }
}