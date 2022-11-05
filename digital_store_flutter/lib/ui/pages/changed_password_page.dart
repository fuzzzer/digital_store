import 'package:digital_store_flutter/ui/widgets/command_button.dart';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../core/constants.dart';

class ChangedPasswordPage extends StatelessWidget {
  ChangedPasswordPage({
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 5),
                Image.asset(ConstantImages.success),
                const SizedBox(height: 115),
                const Text(
                  'Password Changed!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your password has been changed successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF8391A1)),
                ),
                const SizedBox(height: 40),
                CommandButton(
                  width: double.infinity,
                  onPressedFunction: () => context.go('/loginPage'),
                  commandName: 'Back to Login',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
