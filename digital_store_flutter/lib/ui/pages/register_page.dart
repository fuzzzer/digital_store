import 'package:digital_store_flutter/core/constants.dart';
import 'package:digital_store_flutter/data/models/exception_to_widget_data.dart';
import 'package:digital_store_flutter/logic/cubits/data_cubits/user_cubit/user_cubit.dart';
import 'package:digital_store_flutter/ui/pages/login_page.dart';
import 'package:digital_store_flutter/ui/pages/widgets/widgets.dart';
import 'package:digital_store_flutter/ui/widgets/command_button.dart';
import 'package:digital_store_flutter/ui/widgets/credentials_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({
    Key? key,
  }) : super(key: key);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmedPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final platformerWidth = (MediaQuery.of(context).size.width -
            defaultPagePadding.left -
            defaultPagePadding.right -
            8 -
            8) /
        3;

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
              children: [
                GBackButton(
                  onPressed: () => context.go('/loginPage'),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Hello! Register to get started',
                  style: TextStyle(
                    fontSize: 30,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 32),
                CredentialsInput(
                  hintText: 'Username',
                  inputController: usernameController,
                ),
                const SizedBox(height: 15),
                CredentialsInput(
                  hintText: 'Email',
                  inputController: emailController,
                ),
                const SizedBox(height: 15),
                CredentialsInput(
                  hintText: 'Password',
                  obscure: true,
                  inputController: passwordController,
                ),
                const SizedBox(height: 15),
                CredentialsInput(
                  hintText: 'Confirm password',
                  obscure: true,
                  inputController: confirmedPasswordController,
                ),
                const SizedBox(height: 30),
                RegisterButton(
                  usernameController: usernameController,
                  emailController: emailController,
                  passwordController: passwordController,
                  confirmedPasswordController: confirmedPasswordController,
                ),
                const SizedBox(height: 33),
                const OtherPlatformSuggest(
                  suggestion: 'Or Register With',
                ),
                const SizedBox(height: 22),
                Builder(builder: (context) {
                  const facebook = 'assets/icons/facebook_ic.svg';
                  const google = 'assets/icons/google_ic.svg';
                  const apple = 'assets/icons/cib_apple.svg';
                  return Row(
                    children: [
                      AuthenticationPlatform(
                        platformerWidth: platformerWidth,
                        name: facebook,
                        onPressed: () => 'Register with fb',
                      ),
                      const SizedBox(width: 8),
                      AuthenticationPlatform(
                        platformerWidth: platformerWidth,
                        name: google,
                        onPressed: () => 'Register with google',
                      ),
                      const SizedBox(width: 8),
                      AuthenticationPlatform(
                        platformerWidth: platformerWidth,
                        name: apple,
                        onPressed: () => 'Register with apple',
                      ),
                    ],
                  );
                }),
                const Spacer(),
                OtherActionSuggest(
                  question: 'Already have an account?',
                  actionName: 'Login Now',
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

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    Key? key,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmedPasswordController,
  }) : super(key: key);

  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmedPasswordController;

  @override
  Widget build(BuildContext context) {
    return CommandButton(
      width: double.infinity,
      onPressedFunction: () async {
        if (passwordController.text != confirmedPasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('passwords do not match'),
            ),
          );
        } else {
          FallibleMethodResponse loginInfo =
              await context.read<UserCubit>().userSignUp(
                    username: usernameController.text,
                    password: passwordController.text,
                    email: emailController.text,
                  );

          if (loginInfo.isSuccessful == true) {
            context.go('/loginPage');
          }
          print('print ${loginInfo.isSuccessful}');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loginInfo.notificationMessage),
            ),
          );
        }
      },
      commandName: 'Register',
    );
  }
}
