
import 'dart:convert';
import 'package:assistance_flutter/env.dart';
import 'package:http/http.dart' as http;

class HttpService {

  final String _base = Env.serverUrl;

  HttpService();

  Future<http.Response> getRequest(String endpoint) async {

    final url = Uri.https(_base,endpoint);
    final response = await http.get(url, headers: _headers());
    _handleErrors(response);
    return response;
  }

  Future<http.Response> postRequest(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.https(_base,endpoint);
    final response = await http.post(url, headers: _headers(), body: json.encode(body));
    _handleErrors(response);
    return response;
  }

  Future<http.Response> updateRequest(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.https(_base,endpoint);
    final response = await http.put(url, headers: _headers(), body: json.encode(body));
    _handleErrors(response);
    return response;
  }

  // Add other methods like putRequest, deleteRequest, etc.

  Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer your_api_token', // Example for auth header
    };
  }

  void _handleErrors(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('HTTP request failed with status: ${response.statusCode}, body: ${response.body}');
    }
  }
}