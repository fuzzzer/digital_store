import 'package:flutter/material.dart';

const defaultPagePadding = EdgeInsets.only(
  left: 22,
  right: 22,
  top: 40,
  bottom: 26,
);
const double defaultDialogActionFontSize = 20;

enum Sex { male, female, other }

class SvgIcons {}

class ConstantImages {
  static const String authenticatedUser =
      'assets/images/user_authenticated.png';
  static const String unauthenticatedUser =
      'assets/images/user_unauthenticated.png';
  static const String welcomeShoe = 'assets/images/welcome_shoe.jpg';
  static const String garaj = 'assets/images/garaj.png';
  static const String success = 'assets/images/success_image.png';
}
