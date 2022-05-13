import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  //final String label;
  final double relativeHeight;
  final double relativeWidth;
  final double topPadding;
  final TextInputType keyboardType;
  final int maxLines;
  final bool isHidden;
  final String hintText;
  final double fontSize;
  final Color color;
  final String startingText;
  final TextEditingController inputController;
  final Function? onChanged;

  const TextInput(
      {Key? key,
      this.relativeHeight = 1 / 15,
      this.relativeWidth = 0.9,
      this.topPadding = 8,
      this.keyboardType = TextInputType.text,
      this.maxLines = 1,
      this.isHidden = false,
      this.hintText = '',
      this.fontSize = 20,
      this.color = Colors.black,
      this.startingText = '',
      required this.inputController,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.fromLTRB(8, topPadding, 8, 10),
      child: SizedBox(
        width: width * relativeWidth,
        height: height * relativeHeight,
        child: TextField(
            maxLines: maxLines,
            keyboardType: keyboardType,
            controller: inputController,
            onChanged: (_) {
              if (onChanged != null) {
                onChanged!();
              } else {
                null;
              }
            },
            obscureText: isHidden,
            style: TextStyle(color: color, fontSize: fontSize),
            decoration: InputDecoration(
              hintText: hintText,
              alignLabelWithHint: true,
              labelStyle: TextStyle(
                color: const Color.fromARGB(177, 93, 86, 86),
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
              ),
            )),
      ),
    );
  }
}
