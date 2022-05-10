import 'package:digital_store_flutter/ui/screens/home_page.dart';
import 'package:digital_store_flutter/ui/widgets/command_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants.dart';

import '../../logic/cubits/data_cubits/user_cubit/user_cubit.dart';
import '../widgets/text_input.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key, final this.loginTitle = ''}) : super(key: key);

  final String loginTitle;
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
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 35),
                  child: Text(loginTitle,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400))),
            ),
            TextInput(
              hintText: 'username',
              inputController: usernameInputController,
            ),
            TextInput(
              hintText: 'password',
              passwordType: true,
              inputController: passwordInputController,
            ),
            CommandButton(
              onPressedFunction: () {
                context.read<UserCubit>().userLogIn(
                    usernameInputController.text, passwordInputController.text);

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              backgroundColor: Colors.blueAccent,
              cmd: 'Log In',
            )
          ],
        ),
      ),
    );
  }
}
