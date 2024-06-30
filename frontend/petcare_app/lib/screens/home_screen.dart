import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> pets = [];
  bool _isLoading = true; // ローディング状態を管理するフラグ

  @override
  void initState() {
    super.initState();
    fetchPets();
  }

  Future<void> fetchPets() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken != null) {
        final response = await http.get(
          Uri.parse('http://localhost:8000/api/pets/'),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            pets = data['pets'];
            _isLoading = false; // ローディングを終了
          });
        } else {
          throw Exception('Failed to fetch pets');
        }
      } else {
        throw Exception('Access token not found');
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false; // エラー時にもローディングを終了
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Care App'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // ローディング中はインジケーターを表示
          : pets.isEmpty
              ? Center(child: Text('No pets found'))
              : ListView.builder(
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    return Card(
                      margin: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(pet['image']),
                        ),
                        title: Text(
                          pet['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(pet['breed']),
                        trailing: Text('${pet['age']} years'),
                      ),
                    );
                  },
                ),
    );
  }
}
