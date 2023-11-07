import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.pop(context),
      style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
          elevation: 0),
      child: Icon(
        Icons.arrow_back,
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}
