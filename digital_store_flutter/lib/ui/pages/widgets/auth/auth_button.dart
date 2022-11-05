import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
    required this.onPressed,
    this.height = 56,
    required this.label,
    this.labelColor,
    this.backgroudColor,
    this.borderColor,
  }) : super(key: key);

  final VoidCallback onPressed;

  final Color? backgroudColor;
  final Color? borderColor;
  final double height;

  final String label;

  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          padding:
              MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: borderColor ?? Colors.black,
              ),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            backgroudColor ?? Colors.black,
          ),
        ),
        onPressed: onPressed,
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: labelColor),
          ),
        ),
      ),
    );
  }
}
