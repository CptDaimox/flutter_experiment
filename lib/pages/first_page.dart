// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        title: const Center(child: Text('First')),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.logout))],
      ),
      drawer: Drawer(
        backgroundColor: Colors.deepPurple,
        child: Column(children: [
          DrawerHeader(child: Icon(Icons.favorite, size: 48)),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('H O M E'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('S E T T I N G S'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          )
        ]),
      ),
    );
  }
}
