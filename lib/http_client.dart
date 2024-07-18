import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  final String baseUrl = 'https://react-course-b798e-default-rtdb.firebaseio.com/';

  factory HttpClient() {
    return _instance;
  }

  HttpClient._internal();

  Future<http.Response> get(String endpoint, {Map<String, String>? params}) async {
    final Uri uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
    final String? token = await _getToken();
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return await http.get(uri, headers: headers);
  }

  Future<http.Response> post(String endpoint, dynamic data) async {
    final Uri uri = Uri.parse('$baseUrl$endpoint');
    final String? token = await _getToken();
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return await http.post(uri, headers: headers, body: jsonEncode(data));
  }

  Future<http.Response> put(String endpoint, dynamic data) async {
    final Uri uri = Uri.parse('$baseUrl$endpoint');
    final String? token = await _getToken();
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return await http.put(uri, headers: headers, body: jsonEncode(data));
  }

  Future<http.Response> delete(String endpoint) async {
    final Uri uri = Uri.parse('$baseUrl$endpoint');
    final String? token = await _getToken();
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return await http.delete(uri, headers: headers);
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('idToken');
  }
}
