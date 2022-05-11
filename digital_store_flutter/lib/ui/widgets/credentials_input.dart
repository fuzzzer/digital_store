import 'package:flutter/material.dart';

class CredentialsInput extends StatefulWidget {
  final String hintText;
  final bool passwordType;
  late bool isHidden;
  final int maxLines;
  final TextEditingController inputController;

  CredentialsInput(
      {Key? key,
      final this.hintText = '',
      final this.passwordType = false,
      final this.maxLines = 1,
      required final this.inputController})
      : super(key: key) {
    isHidden = passwordType;
  }

  @override
  State<CredentialsInput> createState() {
    return _TextInputState();
  }
}

class _TextInputState extends State<CredentialsInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: 400,
        height: 60,
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: const Color.fromARGB(206, 37, 122, 191),
          child: SizedBox(
            height: double.infinity,
            child: Align(
              alignment: Alignment.center,
              child: TextField(
                controller: widget.inputController,
                obscureText: widget.isHidden,
                textAlign: TextAlign.start,
                maxLines: widget.maxLines,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Color.fromARGB(255, 0, 0, 0)),
                decoration: InputDecoration(
                  labelText: widget.hintText,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 19, 67, 112), width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 163, 163, 163),
                          width: 1.5)),
                  suffixIcon: Opacity(
                    opacity: 1.0,
                    child: widget.passwordType
                        ? IconButton(
                            icon: Icon(
                                widget.isHidden
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color.fromARGB(111, 0, 187, 212)),
                            onPressed: () {
                              setState(() {
                                widget.isHidden = !widget.isHidden;
                              });
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
