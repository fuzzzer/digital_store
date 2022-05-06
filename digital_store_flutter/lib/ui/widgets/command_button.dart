import 'package:flutter/material.dart';

class CommandButton extends StatelessWidget {
  final String cmd;
  final Function onPressedFunction;
  final Color backgroundColor;
  final Color textColor;
  final double width;

  const CommandButton(
      {Key? key,
      final this.cmd = '',
      required final this.onPressedFunction,
      final this.backgroundColor = Colors.white,
      final this.textColor = Colors.black,
      final this.width = 100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: width,
        child: ElevatedButton(
          style:
              ElevatedButton.styleFrom(elevation: 10, primary: backgroundColor),
          child: Text(
            cmd,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w800),
          ),
          onPressed: () => onPressedFunction(),
        ),
      ),
    );
  }
}
