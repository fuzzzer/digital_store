import 'package:flutter/material.dart';

import '../../core/constants.dart';

class CheckDialog extends StatelessWidget {
  const CheckDialog(
      {Key? key,
      this.title = '',
      this.commandName = '',
      required this.onCommandFunction,
      this.commandButtonColor = Colors.red})
      : super(key: key);

  final String title;
  final String commandName;
  final Function onCommandFunction;
  final Color commandButtonColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        title,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onCommandFunction();
          },
          child: Text(
            commandName,
            style: TextStyle(
                color: commandButtonColor,
                fontSize: defaultDialogActionFontSize),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: defaultDialogActionFontSize),
          ),
        ),
      ],
    );
  }
}
