import 'package:digital_store_flutter/ui/pages/widgets/widgets.dart';
import 'package:digital_store_flutter/ui/widgets/command_button.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: defaultPagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GBackButton(),
                const SizedBox(height: 28),
                const Text(
                  'Verification',
                  style: TextStyle(
                    fontSize: 30,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter the verification code we just sent on your email address',
                  style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF8391A1)),
                ),
                const SizedBox(height: 32),
                const Text('Tiles'),
                const SizedBox(height: 38),
                const VerificationButton(
                  verificationCode: '123456',
                ),
                const SizedBox(height: 33),
                const Spacer(),
                OtherActionSuggest(
                  question: 'Didn\'t recieved code?',
                  actionName: 'Resend',
                  onActionPressed: () => print('resend code'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VerificationButton extends StatelessWidget {
  const VerificationButton({
    required this.verificationCode,
    Key? key,
  }) : super(key: key);

  final String verificationCode;

  @override
  Widget build(BuildContext context) {
    return CommandButton(
      width: double.infinity,
      onPressedFunction: () async {
        context.push('/resetPasswordPage');
        //TODO Send password change, email verification related requests
      },
      commandName: 'Verify',
    );
  }
}
