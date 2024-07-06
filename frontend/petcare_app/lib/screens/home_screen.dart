import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // 追加：UTF-8デコード用
import 'package:shared_preferences/shared_preferences.dart';
import 'pet_detail_screen.dart'; // 追加：PetDetailScreenのインポート
import '../services/auth_service.dart'; // AuthServiceのインポート

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> pets = [];
  bool _isLoading = true; // ローディング状態を管理するフラグ
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _authService.refreshToken();
    fetchPets();
  }

  Future<void> fetchPets() async {
    try {
      String? accessToken = await _authService.getAccessToken();

      if (accessToken != null) {
        final response = await http.get(
          Uri.parse('http://localhost:8000/api/pets/'),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (response.statusCode == 200) {
          // UTF-8デコード
          final data = json.decode(utf8.decode(response.bodyBytes));
          if (data != null && data is List) {
            setState(() {
              pets = data;
              _isLoading = false; // ローディングを終了
            });
          } else {
            print('Unexpected response format');
            setState(() {
              _isLoading = false; // エラー時にもローディングを終了
            });
          }
        } else {
          throw Exception('Failed to fetch pets: ${response.reasonPhrase}');
        }
      } else {
        throw Exception('Access token not found');
      }
    } catch (e) {
      print('Error fetching pets: $e');
      setState(() {
        _isLoading = false; // エラー時にもローディングを終了
      });
    }
  }

  bool _isValidUrl(String? url) {
    if (url == null || url.isEmpty) {
      return false;
    }
    Uri? uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasAbsolutePath &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Care App'),
        backgroundColor: Colors.green, // AppBarの色を緑に設定
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Colors.green)) // ローディング中は緑のインジケーターを表示
          : pets.isEmpty
              ? Center(
                  child: Text('No pets found',
                      style: TextStyle(color: Colors.green)))
              : ListView.builder(
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    final imageUrl =
                        _isValidUrl(pet['photo']) ? pet['photo'] : null;
                    return Card(
                      margin: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.green[50], // カードの背景色を緑系に設定
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PetDetailScreen(pet: pet),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage: imageUrl != null
                              ? NetworkImage(imageUrl)
                              : AssetImage('assets/default_image.jpg'),
                          radius: 30.0,
                        ),
                        title: Text(
                          pet['name'] ?? 'Unknown',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800], // タイトルの色を濃い緑に設定
                          ),
                        ),
                        subtitle: Text(
                          pet['species'] ?? 'Unknown',
                          style: TextStyle(
                              color: Colors.green[600]), // サブタイトルの色を緑に設定
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '誕生日',
                              style: TextStyle(
                                color: Colors.green[700], // 誕生日ラベルの色を緑に設定
                              ),
                            ),
                            Text(
                              pet['birthday']?.toString() ?? 'Unknown',
                              style: TextStyle(
                                color: Colors.green[900], // 誕生日の色を濃い緑に設定
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              await Navigator.pushNamed(context, '/register'); // ペット登録画面に遷移
          if (result == true) {
            // ペット登録が成功した場合に再度ペットデータをフェッチ
            setState(() {
              _isLoading = true;
            });
            fetchPets();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green, // FABの色を緑に設定
      ),
    );
  }
}
