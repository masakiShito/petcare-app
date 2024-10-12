import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';
import '../screens/pet_registration_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> pets = [];
  bool _isLoading = true;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    fetchPets();
  }

  // ペット一覧を取得する関数
  Future<void> fetchPets() async {
    try {
      String? accessToken = await _authService.getAccessToken();
      if (accessToken != null) {
        final response = await http.get(
          Uri.parse('http://localhost:8000/api/pets/'),
          headers: {'Authorization': 'Bearer $accessToken'},
        );

        if (response.statusCode == 200) {
          final data = json.decode(utf8.decode(response.bodyBytes));
          setState(() {
            pets = data;
            _isLoading = false;
          });
        } else {
          print('Failed to fetch pets: ${response.statusCode}');
        }
      } else {
        print('Access token not found');
      }
    } catch (e) {
      print('Error fetching pets: $e');
    }
  }

  // ペット登録画面に遷移し、成功後にリロード
  Future<void> _navigateToRegister() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PetRegistrationScreen()),
    );
    if (result == true) {
      fetchPets(); // ペット登録後にリストを再取得
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Care App'),
        backgroundColor: Colors.green.shade400,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // ログアウト処理
              _authService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.green.shade50,
        padding: const EdgeInsets.all(10.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : pets.isEmpty
                ? Center(
                    child: Text(
                      'No pets found',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      final pet = pets[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.green.shade100,
                            child: Icon(
                              Icons
                                  .pets, // Use pets icon for both dogs and cats
                              color: Colors.green.shade800,
                              size: 30,
                            ),
                          ),
                          title: Text(
                            pet['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.green.shade700,
                            ),
                          ),
                          subtitle: Text(
                            pet['species'],
                            style: TextStyle(
                              color: Colors.green.shade600,
                              fontSize: 16,
                            ),
                          ),
                          trailing: Text(
                            '誕生日: ${pet['birthday'] ?? 'Unknown'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green.shade500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToRegister,
        backgroundColor: Colors.green.shade400,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
