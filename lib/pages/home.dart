// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_experiment/components/appbar.dart';
import 'package:flutter_experiment/components/drawer.dart';
import 'package:flutter_experiment/components/textfield.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController newPostController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Home"),
      drawer: MyDrawer(),
      body: Column(
        children: [
          // Textfield
          Padding(
            padding: const EdgeInsets.all(25),
            child: MyTextField(
                hintText: "Say something",
                obscureText: false,
                controller: newPostController),
          )
        ],
      ),
    );
  }
}
