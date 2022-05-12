import 'package:digital_store_flutter/core/constants.dart';
import 'package:digital_store_flutter/ui/screens/login_page.dart';
import 'package:digital_store_flutter/ui/widgets/command_button.dart';
import 'package:digital_store_flutter/ui/widgets/text_input.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubits/data_cubits/user_cubit/user_cubit.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final usernameInputController = TextEditingController();
  final firstNameInputController = TextEditingController();
  final lastNameInputController = TextEditingController();
  final passwordInputController = TextEditingController();
  final repeatedPasswordInputController = TextEditingController();
  final emailInputController = TextEditingController();
  final adressInputController = TextEditingController();
  final phoneNumberInputController = TextEditingController();

  DateTime selectedBirthDate = DateTime.now();
  Gender? selectedGender;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedBirthDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedBirthDate) {
      setState(() {
        selectedBirthDate = picked;
      });
    }
  }

  void selectGender(Gender? value) {
    setState(() {
      selectedGender = value;
    });
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextInput(
                hintText: 'username',
                inputController: usernameInputController,
              ),
              TextInput(
                hintText: 'password',
                inputController: passwordInputController,
                isHidden: true,
              ),
              TextInput(
                hintText: 'repeat password',
                inputController: repeatedPasswordInputController,
                isHidden: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextInput(
                    hintText: 'First Name',
                    inputController: firstNameInputController,
                    relativeWidth: 0.40,
                  ),
                  TextInput(
                    hintText: 'Last Name',
                    inputController: lastNameInputController,
                    relativeWidth: 0.40,
                  ),
                ],
              ),
              TextInput(
                hintText: 'user@email.com',
                inputController: emailInputController,
              ),
              TextInput(
                hintText: 'phone number',
                inputController: phoneNumberInputController,
                keyboardType: TextInputType.number,
              ),
              TextInput(
                hintText: 'Adress',
                maxLines: 4,
                inputController: adressInputController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: width * 0.9,
                  child: Row(children: [
                    Expanded(
                        child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Color.fromARGB(255, 59, 59, 59),
                        ),
                        children: <TextSpan>[
                          const TextSpan(text: 'Select birth date: '),
                          TextSpan(
                              text:
                                  '${selectedBirthDate.day}/${selectedBirthDate.month}/${selectedBirthDate.year}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Colors.black)),
                        ],
                      ),
                    )),
                    ElevatedButton(
                      onPressed: () => selectDate(context),
                      child: const Text('Change'),
                    ),
                  ]),
                ),
              ),
              SizedBox(
                width: width * 0.9,
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Select Gender:',
                    style: TextStyle(color: Color.fromARGB(255, 59, 59, 59)),
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
                      Radio<Gender>(
                        value: Gender.men,
                        groupValue: selectedGender,
                        onChanged: (Gender? value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                      ),
                    ]),
                    Column(children: [
                      const Text('Woman'),
                      Radio<Gender>(
                        value: Gender.woman,
                        groupValue: selectedGender,
                        onChanged: (Gender? value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                      ),
                    ]),
                    Column(children: [
                      const Text('Other'),
                      Radio<Gender>(
                        value: Gender.other,
                        groupValue: selectedGender,
                        onChanged: (Gender? value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                      ),
                    ]),
                  ],
                ),
              ),
              CommandButton(
                  commandName: 'SIGN UP',
                  onPressedFunction: () async {
                    if (passwordInputController.text !=
                        repeatedPasswordInputController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('passwords do not match')));
                    } else {
                      List loginInfo = await context
                          .read<UserCubit>()
                          .userSignUp(
                              username: usernameInputController.text,
                              password: passwordInputController.text,
                              firstName: firstNameInputController.text,
                              lastName: lastNameInputController.text,
                              email: emailInputController.text,
                              phoneNumber: phoneNumberInputController.text,
                              adress: adressInputController.text,
                              birthDate: selectedBirthDate.toString(),
                              gender: selectedGender.toString());

                      if (loginInfo[0] == true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      }

                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(loginInfo[1])));
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
