import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  //final String label;
  final double relativeHeight;
  final double relativeWidth;
  final TextInputType keyboardType;
  final int maxLines;
  final bool isHidden;
  final String hintText;
  final double fontSize;
  final Color color;
  final String startingText;
  final TextEditingController inputController;

  const TextInput(
      {Key? key,
      //this.label = '',
      this.relativeHeight = 1 / 15,
      this.relativeWidth = 0.9,
      this.keyboardType = TextInputType.text,
      this.maxLines = 1,
      this.isHidden = false,
      this.hintText = '',
      this.fontSize = 20,
      this.color = Colors.black,
      this.startingText = '',
      required this.inputController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: SizedBox(
        width: width * relativeWidth,
        height: height * relativeHeight,
        child: TextField(
            maxLines: maxLines,
            keyboardType: keyboardType,
            controller: inputController,
            obscureText: isHidden,
            style: TextStyle(color: color, fontSize: fontSize),
            decoration: InputDecoration(
              //labelText: label,
              hintText: hintText,
              alignLabelWithHint: true,

              labelStyle: TextStyle(
                color: const Color.fromARGB(177, 93, 86, 86),
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
              ),
              // enabledBorder: OutlineInputBorder(
              //   borderSide: const BorderSide(
              //       color: Color.fromARGB(210, 0, 0, 0), width: 1.2),
              //   borderRadius: BorderRadius.circular(10),
              // ),
              // focusedBorder: OutlineInputBorder(
              //   borderSide: const BorderSide(
              //       color: Color.fromARGB(155, 69, 152, 229), width: 1.2),
              //   borderRadius: BorderRadius.circular(10),
              // ),
            )),
      ),
    );
  }
}
