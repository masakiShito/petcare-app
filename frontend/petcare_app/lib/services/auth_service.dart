import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'access_token', value: data['access']);
      await storage.write(key: 'refresh_token', value: data['refresh']);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> refreshToken() async {
    final refreshToken = await storage.read(key: 'refresh_token');
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/token/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'access_token', value: data['access']);
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  Future<String?> getAccessToken() async {
    final accessToken = await storage.read(key: 'access_token');
    return accessToken;
  }
}
