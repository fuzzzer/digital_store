import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  late final String hintText;
  late bool hidden;
  final bool passwordType;
  final int maxLines;
  final TextEditingController inputController;

  TextInput(
      {Key? key,
      final this.hintText = '',
      final this.passwordType = false,
      final this.maxLines = 1,
      required final this.inputController})
      : super(key: key) {
    hidden = passwordType;
  }

  @override
  State<TextInput> createState() {
    return _TextInputState();
  }
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                obscureText: widget.hidden,
                textAlign: TextAlign.start,
                maxLines: widget.maxLines,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 0, 0, 0)),
                decoration: InputDecoration(
                  labelText: widget.hintText,
                  hintText: widget.hintText,
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
                              widget.hidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorLight,
                            ),
                            onPressed: () {
                              setState(() {
                                widget.hidden = !widget.hidden;
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
