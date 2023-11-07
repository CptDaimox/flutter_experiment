import 'package:flutter/material.dart';
import 'package:flutter_experiment/pages/login.dart';
import 'package:flutter_experiment/pages/register.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLogin = true;

  void togglePages() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return LoginPage(switchPage: togglePages);
    } else {
      return RegisterPage(switchPage: togglePages);
    }
  }
}
