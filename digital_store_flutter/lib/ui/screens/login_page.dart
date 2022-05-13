import 'package:digital_store_flutter/ui/screens/home_page.dart';
import 'package:digital_store_flutter/ui/screens/sign_up_page.dart';
import 'package:digital_store_flutter/ui/widgets/command_button.dart';
import 'package:digital_store_flutter/ui/widgets/remember_me.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants.dart';

import '../../logic/cubits/data_cubits/user_cubit/user_cubit.dart';
import '../widgets/credentials_input.dart';

class LoginPage extends StatelessWidget {
  LoginPage({
    Key? key,
  }) : super(key: key);

  final TextEditingController usernameInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: defaultPagePadding,
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 35),
                  child: Text('Log in or register to buy products',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400))),
            ),
            CredentialsInput(
              hintText: 'username',
              inputController: usernameInputController,
            ),
            CredentialsInput(
              hintText: 'password',
              passwordType: true,
              inputController: passwordInputController,
            ),
            const RememberMe(),
            CommandButton(
              onPressedFunction: () async {
                List loginInfo = await context.read<UserCubit>().userLogin(
                    usernameInputController.text, passwordInputController.text);

                if (loginInfo[0] == true) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                }

                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(loginInfo[1])));
              },
              backgroundColor: Colors.blueAccent,
              commandName: 'LOGIN',
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage())),
                    child: const Text('SIGN UP')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
