import 'package:flutter/material.dart';
import 'package:flutter_experiment/auth/auth.dart';
import 'package:flutter_experiment/auth/login_or_register.dart';
import 'package:flutter_experiment/pages/home.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: AuthService.instance.authState,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data == true
              ? HomePage()
              : const LoginOrRegister();
        },
      ),
    );
  }
}
