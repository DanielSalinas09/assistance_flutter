import 'package:assistance_flutter/services/http_service.dart';
import 'package:http/http.dart' as http;


class AssistanceService{

  final httpService=HttpService();

  Future<dynamic>takeAsistance(Map<String, dynamic> body)async{
     try {
      final response =await this.httpService.postRequest('assistance/take/teacher', body);
      return response;
     }catch(e){
      print('Error: $e');
     }
    
  }
}