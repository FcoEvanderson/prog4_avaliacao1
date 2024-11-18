import 'package:flutter/material.dart';

class PersonalizedButton extends StatelessWidget {
  final bool textButton;
  final String buttonText;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const PersonalizedButton({
    super.key,
    required this.textButton,
    required this.buttonText,
    required this.onPressed,
    this.backgroundColor, 
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return textButton ?
      TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
        ),
        onPressed: onPressed, 
        child: Text(buttonText)
      )
    : ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
        ),
        onPressed: onPressed, 
        child: Text(buttonText),
    );
  }
}
