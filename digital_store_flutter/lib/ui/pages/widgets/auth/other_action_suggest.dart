import 'package:flutter/material.dart';

class OtherActionSuggest extends StatelessWidget {
  const OtherActionSuggest({
    Key? key,
    required this.question,
    required this.actionName,
    required this.onActionPressed,
  }) : super(key: key);

  final String question;
  final String actionName;
  final Function() onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 15,
            letterSpacing: 0.03,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1E232C),
          ),
        ),
        GestureDetector(
          onTap: onActionPressed,
          child: Text(
            ' $actionName',
            style: const TextStyle(
              fontSize: 15,
              letterSpacing: 0.03,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 75, 173, 160),
            ),
          ),
        ),
      ],
    );
  }
}
