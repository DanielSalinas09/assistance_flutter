import 'dart:convert';

import 'package:assistance_flutter/services/http_service.dart';


class AssistanceService{

  final httpService=HttpService();

  Future<Map<String,dynamic>>takeAsistance(Map<String, dynamic> body)async{
     try {
      final response =await this.httpService.postRequest('assistance/take/student', body);
      final decodeResponse = json.decode(response.body);
      return decodeResponse;
     }catch(e){
      print('Error: $e');
      return {"status":false,"error":e};
     }
    
  }
}