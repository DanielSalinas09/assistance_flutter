import 'dart:convert';

import 'package:assistance_flutter/helper/exception.dart';
import 'package:assistance_flutter/services/http_service.dart';


class AuthService {

  final httpService=HttpService();
  

  Future<Map<String,dynamic>> login(Map<String, dynamic> body) async {
    try {
      
      final response =await httpService.postRequest('auth/login/student', body);

      final decodeResponse = json.decode(response.body);
      return decodeResponse;
     }on AppException catch(err){
  
      return {"status":false,"error":err.message};
     }
  }

  Future<Map<String,dynamic>> verifyIdentity(Map<String, dynamic> body) async {
    try {
      
      final response =await httpService.postRequest('auth/login/student/verifyIdentity', body);

      final decodeResponse = json.decode(response.body);
      return decodeResponse;
     }catch(e){
      print('Error: $e');
      final error = json.decode(e.toString());
       print('Error2: $error');
      return {"status":false,"error":e.toString()};
     }
  }

  Future<Map<String,dynamic>> forgetPassword(Map<String, dynamic> body) async {
    try {
      
      final response =await httpService.postRequest('auth/login/student/forgetPassword', body);

      final decodeResponse = json.decode(response.body);
      return decodeResponse;
     }catch(e){
      print('Error: $e');
      final error = json.decode(e.toString());
       print('Error2: $error');
      return {"status":false,"error":e.toString()};
     }
  }

  

  Future<Map<String,dynamic>> checkUserSession() async {
    try {
      
      final response =await httpService.getRequest('auth/current-authenticated-user');

      final decodeResponse = json.decode(response.body);
      return decodeResponse;
     }catch(e){
  
      return {"status":false,"error":e.toString()};
     }
  }
}