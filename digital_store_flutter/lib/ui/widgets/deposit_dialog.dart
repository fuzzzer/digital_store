import 'package:flutter/material.dart';

import '../../core/constants.dart';

class DepositDialog extends StatelessWidget {
  const DepositDialog(
      {Key? key,
      required this.depositInputController,
      this.commandName = '',
      required this.onCommandFunction,
      this.commandButtonColor = Colors.green})
      : super(key: key);

  final TextEditingController depositInputController;
  final String commandName;
  final Function onCommandFunction;
  final Color commandButtonColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 400,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Expanded(
              child: Text(
                'Deposit: ',
              ),
            ),
            SizedBox(
              width: 100,
              child: Container(
                  //decoration: BoxDecoration(border: Border.all()),
                  color: const Color.fromARGB(169, 158, 158, 158),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: depositInputController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 113, 123, 132),
                            width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 0, 0, 0), width: 1.5)),
                    ),
                  )),
            ),
            const Text(
              ' \$',
              style: TextStyle(fontSize: 20),
            )
          ],
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
      ),
    );
  }
}
