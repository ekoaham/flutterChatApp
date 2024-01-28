import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  late String textValue;
  late Color colorsValue;
  final VoidCallback onPress;
  RoundedButton(@required this.textValue,@required this.colorsValue,  this.onPress);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: colorsValue,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            textValue,
          ),
        ),
      ),
    );
  }
}