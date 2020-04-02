import 'package:flutter/material.dart';

import 'config.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  CustomButton({@required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      color: Config.COLOR_MAIN,
      child:
          Text(text, style: TextStyle(
            color: Config.COLOR_TEXT, 
            fontSize: 34,
            fontWeight: FontWeight.bold,
            )),
    );
  }
}