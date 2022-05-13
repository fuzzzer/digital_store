import 'package:digital_store_flutter/ui/screens/home_page.dart';
import 'package:digital_store_flutter/ui/screens/user_profile_info_page.dart';
import 'package:digital_store_flutter/ui/widgets/command_button.dart';
import 'package:digital_store_flutter/ui/widgets/deposit_dialog.dart';
import 'package:digital_store_flutter/ui/widgets/orders_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants.dart';
import '../../logic/cubits/data_cubits/user_cubit/user_cubit.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: defaultPagePadding,
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UserConsumer) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(state.user.username,
                              style: const TextStyle(fontSize: 30)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    const TextSpan(text: 'Balance: '),
                                    TextSpan(
                                        text: '${state.user.balance} \$',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.blue,
                                            fontSize: 25)),
                                  ],
                                ),
                              ),
                            ),
                            CommandButton(
                                commandName: 'Deposit',
                                backgroundColor: Colors.green,
                                onPressedFunction: () {
                                  TextEditingController depositInputController =
                                      TextEditingController();
                                  showDialog(
                                    context: context,
                                    builder: (context) => DepositDialog(
                                      commandName: 'Pay',
                                      depositInputController:
                                          depositInputController,
                                      onCommandFunction: () => context
                                          .read<UserCubit>()
                                          .updateBalance(double.parse(
                                              depositInputController.text)),
                                      // get amout and change balance
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                      CommandButton(
                          width: double.infinity,
                          backgroundColor: Colors.blue,
                          fontWeight: FontWeight.w600,
                          commandName: 'update user profile info',
                          onPressedFunction: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserProfileInfoPage(
                                        user: state.user,
                                      )))),
                      const OrdersPreview(),
                      CommandButton(
                          commandName: 'sign out',
                          onPressedFunction: () {
                            context.read<UserCubit>().logout();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                                (Route<dynamic> route) => false);
                          }),
                    ],
                  );
                } else {
                  return const Center(child: Text('some problem'));
                }
              },
            )));
  }
}
