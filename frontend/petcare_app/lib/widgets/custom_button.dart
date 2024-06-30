import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  CustomButton({
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 32.0,
          vertical: 16.0,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 18.0, color: textColor),
      ),
    );
  }
}
