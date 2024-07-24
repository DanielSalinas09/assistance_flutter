


import 'package:assistance_flutter/services/http_service.dart';


class AuthService {

  final httpService=HttpService();

  Future<dynamic> login(Map<String, dynamic> body) async {
    try {
      final response =await this.httpService.postRequest('auth/login/student', body);
      print("RESPONSE: ${response}");
      return response;
     }catch(e){
      print('Error: $e');
     }
  }
}