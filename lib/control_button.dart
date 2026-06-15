import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const ControlButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 13),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}