


import 'package:assistance_flutter/services/http_service.dart';
import 'package:http/http.dart';


class ScheduleService {

  final httpService=HttpService();

  Future<Response> getSchedule(String id) async {
    try {
      final response =await this.httpService.getRequest('courses/schedule-by/student/$id');
      print("response $response");
      return response;
     }catch(e){
      print('Error: $e');
      rethrow;
     }
  }
}