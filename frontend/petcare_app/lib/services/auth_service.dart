import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final storage = FlutterSecureStorage();

  // ログイン処理 (トークンを取得して保存)
  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'access_token', value: data['access']);
      await storage.write(key: 'refresh_token', value: data['refresh']);
    } else {
      throw Exception('Failed to login');
    }
  }

  // アクセストークンをリフレッシュ
  Future<void> refreshToken() async {
    final refreshToken = await storage.read(key: 'refresh_token');

    if (refreshToken != null) {
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
    } else {
      throw Exception('No refresh token found');
    }
  }

  // アクセストークンを取得 (無効な場合はリフレッシュ)
  Future<String?> getAccessToken() async {
    String? accessToken = await storage.read(key: 'access_token');
    if (accessToken != null && await isTokenExpired(accessToken)) {
      await refreshToken(); // トークンが期限切れの場合、リフレッシュ
      accessToken = await storage.read(key: 'access_token');
    }
    return accessToken;
  }

  // トークンの有効期限を確認する (JWTのpayloadを確認)
  Future<bool> isTokenExpired(String token) async {
    final parts = token.split('.');
    if (parts.length != 3) {
      return true; // トークンの形式が不正
    }
    final payload = json
        .decode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
    final exp = payload['exp'];
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now > exp;
  }

  // ログアウト処理 (トークンを削除)
  Future<void> logout() async {
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'refresh_token');
  }
}
