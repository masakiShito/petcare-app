import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pet_registration_screen.dart';
import 'services/auth_service.dart';
import 'screens/signup_screen.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Care App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/login': (context) => LoginScreen(), // ログイン画面のルート
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/register': (context) => PetRegistrationScreen(),
      },
    );
  }
}

class TokenRefreshManager {
  final AuthService _authService = AuthService();

  void start() {
    Timer.periodic(Duration(minutes: 15), (timer) async {
      try {
        await _authService.refreshToken();
      } catch (e) {
        print('Failed to refresh token: $e');
      }
    });
  }
}
