import 'package:digital_store_flutter/ui/screens/home_page/home_page.dart';
import 'package:digital_store_flutter/ui/screens/login_page/login_page.dart';
import 'package:digital_store_flutter/ui/widgets/check_dialog.dart';
import 'package:flutter/material.dart';

void sessionTimeoutNavigation(final BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LoginPage(
          goBackFunction: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const HomePage(),
          )),
        ),
      ),
      (Route<dynamic> route) => false);

  showDialog(
    context: context,
    builder: (context) {
      return CheckDialog(
        onCommandFunction: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (Route<dynamic> route) => false),
        title:
            'Session timeout, you have to login again or go to the Home Page and continue as guest.',
        commandName: 'Go to Home Page',
        commandButtonColor: Colors.blue,
      );
    },
  );
}
