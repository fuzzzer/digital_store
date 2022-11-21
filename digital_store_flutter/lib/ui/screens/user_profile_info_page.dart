import 'package:digital_store_flutter/core/constants.dart';
import 'package:digital_store_flutter/ui/widgets/command_button.dart';
import 'package:digital_store_flutter/ui/widgets/text_input.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/user.dart';
import '../../logic/cubits/data_cubits/user_cubit/user_cubit.dart';

class UserProfileInfoPage extends StatefulWidget {
  final User user;
  late final TextEditingController firstNameInputController;
  late final TextEditingController lastNameInputController;
  late final TextEditingController emailInputController;
  late final TextEditingController addressInputController;
  late final TextEditingController phoneNumberInputController;

  UserProfileInfoPage({Key? key, required this.user}) : super(key: key) {
    firstNameInputController = TextEditingController(text: user.firstName);
    lastNameInputController = TextEditingController(text: user.lastName);
    emailInputController = TextEditingController(text: user.email);
    addressInputController = TextEditingController(text: user.address);
    phoneNumberInputController = TextEditingController(text: user.phoneNumber);
  }

  @override
  State<UserProfileInfoPage> createState() => _UserProfileInfoPageState();
}

class _UserProfileInfoPageState extends State<UserProfileInfoPage> {
  late Sex? selectedSex;

  @override
  void initState() {
    selectedSex = Sex.values.firstWhere(
        (e) => e.toString().substring(4) == widget.user.sex,
        orElse: () => Sex.other);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: defaultPagePadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('User name:'),
                      ),
                      TextInput(
                        topPadding: 0,
                        inputController: widget.firstNameInputController,
                        relativeWidth: 0.40,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('Last name:'),
                      ),
                      TextInput(
                        topPadding: 0,
                        inputController: widget.lastNameInputController,
                        relativeWidth: 0.40,
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('Email address:'),
              ),
              TextInput(
                topPadding: 0,
                inputController: widget.emailInputController,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('Phone number:'),
              ),
              TextInput(
                topPadding: 0,
                inputController: widget.phoneNumberInputController,
                keyboardType: TextInputType.number,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('Address:'),
              ),
              TextInput(
                topPadding: 0,
                maxLines: 4,
                inputController: widget.addressInputController,
              ),
              SizedBox(
                width: width * 0.9,
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Select sex:',
                      style: TextStyle(color: Color.fromARGB(255, 59, 59, 59)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(children: [
                      const Text('Men'),
                      Radio<Sex>(
                        value: Sex.male,
                        groupValue: selectedSex,
                        onChanged: (Sex? value) {
                          setState(() {
                            selectedSex = value;
                          });
                        },
                      ),
                    ]),
                    Column(children: [
                      const Text('Woman'),
                      Radio<Sex>(
                        value: Sex.female,
                        groupValue: selectedSex,
                        onChanged: (Sex? value) {
                          setState(() {
                            selectedSex = value;
                          });
                        },
                      ),
                    ]),
                    Column(children: [
                      const Text('Other'),
                      Radio<Sex>(
                        value: Sex.other,
                        groupValue: selectedSex,
                        onChanged: (Sex? value) {
                          setState(() {
                            selectedSex = value;
                          });
                        },
                      ),
                    ]),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Center(
                  child: CommandButton(
                      width: 250,
                      commandName: 'UPDATE PROFILE',
                      onPressedFunction: () async {
                        List loginInfo = await context
                            .read<UserCubit>()
                            .updateProfile(
                                firstName: widget.firstNameInputController.text,
                                lastName: widget.lastNameInputController.text,
                                email: widget.emailInputController.text,
                                phoneNumber:
                                    widget.phoneNumberInputController.text,
                                address: widget.addressInputController.text,
                                sex: selectedSex.toString().substring(4));

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(loginInfo[1])));
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
