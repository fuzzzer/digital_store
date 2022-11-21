import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class GPinInput extends StatefulWidget {
  const GPinInput({
    Key? key,
    this.codeLength = 6,
    required this.onCompleted,
    this.onChanged,
    this.width = 350,
  })  : assert(codeLength > 0),
        super(key: key);

  final int codeLength;
  final Function(String value) onCompleted;
  final Function(String value)? onChanged;
  final double width;

  @override
  State<GPinInput> createState() => _GPinInputState();
}

class _GPinInputState extends State<GPinInput> {
  final FocusNode focusNode = FocusNode();
  final StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  final TextEditingController controller = TextEditingController();
  late final List<String> inputs;

  String code = '';

  Color backgroundColor = const Color(0xFFF7F8F9);
  Color borderColor = const Color(0xFFE8ECF4);

  @override
  void initState() {
    inputs = List.generate(widget.codeLength, (index) => '');
    focusNode.addListener(_onFocusChange);

    super.initState();
  }

  void _onFocusChange() {}

  void onChanged(int index, String value) {
    inputs[index] = value;
    code = inputs.fold<String>('', (previousValue, element) {
      return previousValue + element;
    });

    if (widget.onChanged != null) {
      widget.onChanged!(code);
    }
    checkCompletion();
  }

  void checkCompletion() {
    final isCompleted = inputs.every((element) => element != '');

    if (isCompleted) {
      widget.onCompleted(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double realWidth = min(widget.width, constraints.maxWidth);
        const midPadding = 8.0;
        final double numberBoxWidth =
            (realWidth - (widget.codeLength - 1) * midPadding) /
                widget.codeLength;

        return PinCodeTextField(
          appContext: context,
          length: widget.codeLength,
          obscureText: false,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8),
            borderWidth: 1,
            fieldHeight: 58,
            fieldWidth: numberBoxWidth,
            inactiveFillColor: const Color(0xFFF7F8F9),
            inactiveColor: const Color(0xFFE8ECF4),
            selectedFillColor: Colors.transparent,
            selectedColor: const Color.fromARGB(173, 183, 71, 71),
            activeFillColor: Colors.transparent,
            activeColor: const Color(0xFF35C2C1),
          ),
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          enableActiveFill: true,
          errorAnimationController: errorController,
          controller: controller,
          onCompleted: (value) {
            widget.onCompleted(value);
          },
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
          beforeTextPaste: (text) => true,
        );
      },
    );
  }
}
