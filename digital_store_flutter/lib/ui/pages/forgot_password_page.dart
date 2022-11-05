import 'package:digital_store_flutter/ui/pages/widgets/widgets.dart';
import 'package:digital_store_flutter/ui/widgets/command_button.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';

import '../widgets/credentials_input.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({
    Key? key,
  }) : super(key: key);

  final TextEditingController emailController = TextEditingController();

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
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 30,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Don\'t worry! It occurs. Please enter the email address linked with your account.',
                  style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF8391A1)),
                ),
                const SizedBox(height: 32),
                CredentialsInput(
                  hintText: 'Enter your email',
                  inputController: emailController,
                ),
                const SizedBox(height: 38),
                ForgotPasswordButton(
                  emailInputController: emailController,
                ),
                const SizedBox(height: 33),
                const Spacer(),
                OtherActionSuggest(
                  question: 'Remember Password?',
                  actionName: 'Login',
                  onActionPressed: () => context.push('/loginPage'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({
    Key? key,
    required this.emailInputController,
  }) : super(key: key);

  final TextEditingController emailInputController;

  @override
  Widget build(BuildContext context) {
    return CommandButton(
      width: double.infinity,
      onPressedFunction: () async {
        context.push('/verificationPage');

        //TODO Send password change related requests
        //List loginInfo = await context.read<UserCubit>().userLogin(
        //       usernameInputController.text,
        //       passwordInputController.text,
        //     );

        // if (loginInfo[0] == true) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const HomePage(),
        //     ),
        //   );
        // }

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       loginInfo[1],
        //     ),
        //   ),
        // );
      },
      commandName: 'Send Code',
    );
  }
}
