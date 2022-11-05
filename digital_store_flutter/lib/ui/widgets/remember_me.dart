import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //TODO refactor to remember user in any case,
        // so the check box is not needed any more

        // GestureDetector(
        //   onTap: () {
        //     changeRememberMe();
        //     context.read<UserCubit>().setRememberMeValue();
        //   },
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       SizedBox(
        //         width: 25,
        //         height: 25,
        //         child: Checkbox(
        //           side: const BorderSide(
        //             color: Color(0xFF6A707C),
        //             width: 2,
        //           ),
        //           visualDensity:
        //               const VisualDensity(horizontal: 0, vertical: 0),
        //           checkColor: Colors.white,
        //           fillColor: MaterialStateProperty.all(
        //               const Color.fromARGB(212, 32, 71, 33)),
        //           shape: const CircleBorder(),
        //           value: rememberMe,
        //           onChanged: (_) {
        //             changeRememberMe();
        //             context.read<UserCubit>().setRememberMeValue();
        //           },
        //         ),
        //       ),
        //       const Text(
        //         'Remember Me',
        //         style: TextStyle(
        //           color: Color(0xFF6A707C),
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //       const SizedBox(width: 4),
        //     ],
        //   ),
        // ),
        const Spacer(),
        GestureDetector(
          onTap: () => context.push('/forgotPasswordPage'),
          child: const Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: 14,
              height: 1.2,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6A707C),
            ),
          ),
        ),
      ],
    );
  }
}
