import 'dart:convert';
import 'dart:developer';

import 'package:assistance_flutter/services/http_service.dart';


class AuthService {

  final httpService=HttpService();
  

  Future<Map<String,dynamic>> login(Map<String, dynamic> body) async {
    try {
      
      final response =await httpService.postRequest('auth/login/student', body);

      final decodeResponse = json.decode(response.body);
      return decodeResponse;
     } catch(err){
      log("ERROR LOGIN: $err");
      return {"status":false,"error":err};
     }
  }

  

  Future<Map<String,dynamic>> validateUser(Map<String, dynamic> body) async {
    try {
      
      final response =await httpService.postRequest('auth/validate-user', body);

      final decodeResponse = json.decode(response.body);
      return decodeResponse;
     }catch(e){
       log("ERROR VALIDATE USER: $e");
      return {"status":false,"error":e.toString()};
     }
  }

  Future<Map<String,dynamic>> validatePhone(Map<String, dynamic> body) async {
    try {
      
      final response =await httpService.postRequest('auth/validate-phone', body);

      final decodeResponse = json.decode(response.body);
      return decodeResponse;
     }catch(e){
      log("ERROR VALIDATE PHONE: $e");
      return {"status":false,"error":e.toString()};
     }
  }

  Future<Map<String,dynamic>> changePassword(Map<String, dynamic> body) async {
    try {
      
      final response =await httpService.postRequest('auth/change-password', body);

      final decodeResponse = json.decode(response.body);
      return decodeResponse;
     }catch(e){
      log("ERROR VALIDATE PHONE: $e");
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