import 'package:digital_store_flutter/logic/cubits/data_cubits/user_cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RememberMe extends StatefulWidget {
  const RememberMe({Key? key}) : super(key: key);

  @override
  State<RememberMe> createState() => _RememberMeState();
}

class _RememberMeState extends State<RememberMe> {
  bool rememberMe = false;

  changeRememberMe() {
    setState(() {
      if (rememberMe == false) {
        rememberMe = true;
      } else {
        rememberMe = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Checkbox(
              value: rememberMe,
              onChanged: (_) {
                changeRememberMe();
                context.read<UserCubit>().setRemembered();
              }),
          const Text('Remember Me')
        ],
    );
  }
}
