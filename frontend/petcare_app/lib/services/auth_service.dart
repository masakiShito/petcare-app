import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static const String _baseUrl = 'http://localhost:8000/api';

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login/'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', data['access_token']);
      prefs.setString('refreshToken', data['refresh_token']);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    if (refreshToken != null) {
      final response = await http.post(
        Uri.parse('$_baseUrl/token/refresh/'),
        body: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        prefs.setString('accessToken', data['access']);
      } else {
        throw Exception('Failed to refresh token');
      }
    } else {
      throw Exception('No refresh token found');
    }
  }

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    return accessToken;
  }
}
