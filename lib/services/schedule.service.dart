


import 'package:assistance_flutter/services/http_service.dart';
import 'package:http/http.dart';


class ScheduleService {

  final httpService=HttpService();

  Future<Response> getSchedule(String id) async {
    try {
      final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2OTM1NmFjN2ZlZDBiNmRjNGVjNTI5NiIsIm5hbWUiOiJBbmEiLCJzdXJuYW1lcyI6Ik1hcnTDrW5leiBMw7NwZXoiLCJlbWFpbCI6ImFuYS5tYXJ0aW5lekBleGFtcGxlLmNvbSIsImRuaSI6MzQ1Njc4OTAsInBob25lIjo0NjEyMzQ1Njc4LCJpYXQiOjE3MjE3ODY4MTksImV4cCI6MTcyMTg3MzIxOX0.EWS2X4LSEbqhyfPqDNB_ULN5y8UuSib4sQqAUzYCqbo';
      final response =await this.httpService.getRequest('api/courses/schedule-by/student/$id', token);
      print("response $response");
      return response;
     }catch(e){
      print('Error: $e');
      rethrow;
     }
  }
}