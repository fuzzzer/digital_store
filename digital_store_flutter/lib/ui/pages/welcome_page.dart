import 'package:digital_store_flutter/core/constants.dart';
import 'package:digital_store_flutter/ui/pages/widgets/auth/auth_button.dart';
import 'package:digital_store_flutter/ui/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ConstantImages.welcomeShoe),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              SizedBox(
                height: height / 8,
              ),
              SizedBox(
                height: height / 10,
                child: const Text(
                  'GARAJ®',
                  style: TextStyle(
                    fontFamily: 'Habibi',
                    fontSize: 48,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
              SizedBox(
                height: height / 2,
              ),
              AuthButton(
                label: 'Login',
                onPressed: () => context.push(
                  '/loginPage',
                ),
              ),
              SizedBox(
                height: height / 50,
              ),
              AuthButton(
                label: 'Register',
                onPressed: () => context.push('/registerPage'),
                labelColor: Colors.black,
                backgroudColor: Colors.white,
              ),
              SizedBox(
                height: height / 20,
              ),
              const Spacer(),
              GTextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                ),
                label: 'Continue as a guest',
              ),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}

class GTextButton extends StatefulWidget {
  const GTextButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final String label;
  final Function() onPressed;

  @override
  State<GTextButton> createState() => _GTextButtonState();
}

class _GTextButtonState extends State<GTextButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
        setState(() {
          isPressed = true;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: isPressed ? Colors.grey.shade700 : Colors.black,
            ),
          ),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 15,
            height: 1.2,
            color: isPressed ? Colors.grey.shade700 : Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
