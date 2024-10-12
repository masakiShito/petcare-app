import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景に足跡のパターン画像を表示
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/pet_pattern_background.png'), // 背景画像をここで指定
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              color: Colors.white.withOpacity(0.9),
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'ようこそ Pet Care App へ',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CuteFont',
                          color: Colors.green.shade700,
                        ),
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
                            // ログイン処理
                          }
                        },
                        child: Text('ログイン'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade400,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text(
                          'アカウントを作成',
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
