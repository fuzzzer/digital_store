import 'package:digital_store_flutter/ui/pages/widgets/widgets.dart';
import 'package:digital_store_flutter/ui/widgets/command_button.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';

import '../widgets/credentials_input.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({
    Key? key,
  }) : super(key: key);

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmedPasswordController =
      TextEditingController();

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
                  'Create new password',
                  style: TextStyle(
                    fontSize: 30,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your new password must be unique from those previously used.',
                  style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF8391A1)),
                ),
                const SizedBox(height: 32),
                CredentialsInput(
                  hintText: 'New Password',
                  inputController: passwordController,
                  obscure: true,
                ),
                const SizedBox(height: 15),
                CredentialsInput(
                  hintText: 'Confirm Password',
                  inputController: passwordController,
                  obscure: true,
                ),
                const SizedBox(height: 38),
                ResetPasswordButton(
                  passwordController: passwordController,
                  confirmedPasswordController: confirmedPasswordController,
                ),
                const SizedBox(height: 33),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResetPasswordButton extends StatelessWidget {
  const ResetPasswordButton({
    Key? key,
    required this.passwordController,
    required this.confirmedPasswordController,
  }) : super(key: key);

  final TextEditingController passwordController;
  final TextEditingController confirmedPasswordController;

  @override
  Widget build(BuildContext context) {
    return CommandButton(
      width: double.infinity,
      onPressedFunction: () async {
        context.push('/changedPasswordPage');
        //TODO Send new passwords to back end
      },
      commandName: 'Send Code',
    );
  }
}
