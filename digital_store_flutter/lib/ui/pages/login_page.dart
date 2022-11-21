import 'package:digital_store_flutter/ui/pages/widgets/widgets.dart';
import 'package:digital_store_flutter/ui/screens/home_page.dart';
import 'package:digital_store_flutter/ui/widgets/command_button.dart';
import 'package:digital_store_flutter/ui/widgets/remember_me.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';

import '../../logic/cubits/data_cubits/user_cubit/user_cubit.dart';
import '../widgets/credentials_input.dart';

class LoginPage extends StatelessWidget {
  LoginPage({
    Key? key,
  }) : super(key: key);

  final String pathName = 'loginPage';

  final TextEditingController emailInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();

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
                  onPressed: () => context.go('/'),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Welcome back! Glad to see you, Again!',
                  style: TextStyle(
                    fontSize: 30,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 32),
                CredentialsInput(
                  hintText: 'Enter your email',
                  inputController: emailInputController,
                ),
                const SizedBox(height: 15),
                CredentialsInput(
                  hintText: 'Enter your password',
                  obscure: true,
                  canChangePasswordVisibility: true,
                  inputController: passwordInputController,
                ),
                const SizedBox(height: 15),
                const RememberMe(),
                const SizedBox(height: 33),
                LoginButton(
                  emailInputController: emailInputController,
                  passwordInputController: passwordInputController,
                ),
                const SizedBox(height: 33),
                const OtherPlatformSuggest(suggestion: 'Or Login with'),
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
                        onPressed: () => 'Login with fb',
                      ),
                      const SizedBox(width: 8),
                      AuthenticationPlatform(
                        platformerWidth: platformerWidth,
                        name: google,
                        onPressed: () => 'Login with google',
                      ),
                      const SizedBox(width: 8),
                      AuthenticationPlatform(
                        platformerWidth: platformerWidth,
                        name: apple,
                        onPressed: () => 'Login with apple',
                      ),
                    ],
                  );
                }),
                const Spacer(),
                OtherActionSuggest(
                  question: 'Don’t have an account?',
                  actionName: 'Register Now',
                  onActionPressed: () => context.push('/registerPage'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum LoginPlatformType {
  facebook,
  google,
  apple,
  local,
}

class AuthenticationPlatform extends StatelessWidget {
  const AuthenticationPlatform({
    Key? key,
    required this.platformerWidth,
    required this.name,
    required this.onPressed,
  }) : super(key: key);

  final double platformerWidth;
  final String name;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 56,
        width: platformerWidth,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE8ECF4),
          ),
        ),
        child: Center(
          child: SvgPicture.asset(name),
        ),
      ),
    );
  }
}

class GDivider extends StatelessWidget {
  const GDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      width: MediaQuery.of(context).size.width / 4,
      decoration: const BoxDecoration(
        color: Color(0xFFE8ECF4),
        border: Border.symmetric(
          vertical: BorderSide(
            color: Color(0xFFE8ECF4),
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
    required this.emailInputController,
    required this.passwordInputController,
  }) : super(key: key);

  final TextEditingController emailInputController;
  final TextEditingController passwordInputController;

  @override
  Widget build(BuildContext context) {
    return CommandButton(
      width: double.infinity,
      onPressedFunction: () async {
        List loginInfo = await context.read<UserCubit>().userLogin(
              emailInputController.text,
              passwordInputController.text,
            );

        if (loginInfo[0] == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              loginInfo[1],
            ),
          ),
        );
      },
      commandName: 'Login',
    );
  }
}
