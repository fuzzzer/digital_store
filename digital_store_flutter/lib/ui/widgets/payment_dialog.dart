import 'package:flutter/material.dart';

import '../../core/constants.dart';

class PaymentDialog extends StatelessWidget {
  const PaymentDialog(
      {Key? key,
      required this.balance,
      required this.totalPrice,
      this.commandName = '',
      required this.onCommandFunction,
      this.commandButtonColor = Colors.blue})
      : super(key: key);

  final double balance;
  final double totalPrice;
  final String commandName;
  final Function onCommandFunction;
  final Color commandButtonColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Column(
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              children: <TextSpan>[
                const TextSpan(text: 'Balance: '),
                TextSpan(
                  text: '$balance \$',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.green,
                  ),
                )
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              children: <TextSpan>[
                const TextSpan(text: 'Total Price: '),
                TextSpan(
                  text: '$totalPrice \$',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              children: <TextSpan>[
                const TextSpan(text: 'New balance: '),
                TextSpan(
                  text: '${balance - totalPrice} \$',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
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
