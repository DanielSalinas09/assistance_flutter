


import 'dart:convert';
import 'dart:developer';

import 'package:assistance_flutter/services/http_service.dart';

class UpdatePasswordService{

  final httpService=HttpService();

  Future<Map<String,dynamic>> updatePassword(Map<String, dynamic> body) async {
    try {
      
      final response =await httpService.postRequest('auth/update-password', body);

      final decodeResponse = json.decode(response.body);
      return decodeResponse;
     } catch(err){
      log("ERROR LOGIN: $err");
      return {"status":false,"error":err};
     }
  }

}