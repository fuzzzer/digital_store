import 'package:flutter/material.dart';

class CommandButton extends StatelessWidget {
  final String commandName;
  final Function onPressedFunction;
  final Color backgroundColor;
  final Color textColor;
  final FontWeight fontWeight;
  final double? width;
  final double height;

  const CommandButton({
    Key? key,
    this.commandName = '',
    required this.onPressedFunction,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.w600,
    this.width,
    this.height = 56,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Colors.black),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
        ),
        child: Text(
          commandName,
          style: TextStyle(color: textColor, fontWeight: fontWeight),
        ),
        onPressed: () => onPressedFunction(),
      ),
    );
  }
}
