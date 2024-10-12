import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/users/register/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      // サインアップ成功時にログイン画面へ遷移
      Navigator.pushReplacementNamed(context, '/login');

      // 成功メッセージを表示
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('アカウントが作成されました。ログインしてください。')));
    } else {
      setState(() {
        _errorMessage = 'サインアップに失敗しました。もう一度お試しください。';
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景に足跡パターン画像を表示
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/pet_pattern_background.png'), // 足跡の背景画像を指定
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              color: Colors.white.withOpacity(0.9), // 背景に合わせて透明度を調整
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'サインアップ',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CuteFont',
                          color: Colors.green.shade700,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'ユーザー名',
                          prefixIcon:
                              Icon(Icons.person, color: Colors.green.shade700),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ユーザー名を入力してください';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'メールアドレス',
                          prefixIcon:
                              Icon(Icons.email, color: Colors.green.shade700),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'メールアドレスを入力してください';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'パスワード',
                          prefixIcon:
                              Icon(Icons.lock, color: Colors.green.shade700),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'パスワードを入力してください';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      if (_isLoading) CircularProgressIndicator(),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _signup();
                          }
                        },
                        child: Text('サインアップ'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade400,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text(
                          '既にアカウントをお持ちの方はこちらからログイン',
                          style: TextStyle(color: Colors.green.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
