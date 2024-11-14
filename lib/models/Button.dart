import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  String _buttonText;
  Colors _backgroundColor;
  Function _onPressed;

  Button(this._buttonText, this._backgroundColor, this._onPressed);

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){}, 
      child: Text(''),
    );
  }
}