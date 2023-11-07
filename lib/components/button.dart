import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;

  const MyButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          )),
      onPressed: onPressed,
      child: Center(
        child: Text(label,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge!.color)),
      ),
    );
  }
}
