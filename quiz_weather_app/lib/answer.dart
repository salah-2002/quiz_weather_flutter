import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const AnswerButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: FilledButton.tonal(
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Text(text),
        ),
      ),
    );
  }
}
