import 'package:flutter/material.dart';

class CredentialsInput extends StatefulWidget {
  final String hintText;
  final bool obscure;
  final int maxLines;
  final TextEditingController inputController;
  final bool canChangePasswordVisibility;

  const CredentialsInput({
    Key? key,
    this.hintText = '',
    this.obscure = false,
    this.maxLines = 1,
    required this.inputController,
    this.canChangePasswordVisibility = false,
  }) : super(key: key);

  @override
  State<CredentialsInput> createState() {
    return _TextInputState();
  }
}

class _TextInputState extends State<CredentialsInput> {
  late bool isHidden;

  @override
  void initState() {
    isHidden = widget.obscure;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashColor: const Color(0xFFF7F8F9)),
      child: TextFormField(
        controller: widget.inputController,
        obscureText: isHidden,
        textAlign: TextAlign.start,
        maxLines: widget.maxLines,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color.fromARGB(255, 42, 47, 52),
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: const Color(0xFFF7F8F9),
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 19),
          labelText: widget.hintText,
          hintStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color(0xFF8391A1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 19, 67, 112),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFFE8ECF4),
              width: 1,
            ),
          ),
          suffixIcon: widget.canChangePasswordVisibility
              ? Opacity(
                  opacity: 0.7,
                  child: widget.obscure
                      ? IconButton(
                          splashRadius: 24,
                          icon: Icon(
                            isHidden ? Icons.visibility : Icons.visibility_off,
                            color: const Color(0xFF6A707C),
                          ),
                          onPressed: () {
                            setState(() {
                              isHidden = !isHidden;
                            });
                          },
                        )
                      : null,
                )
              : null,
        ),
      ),
    );
  }
}
