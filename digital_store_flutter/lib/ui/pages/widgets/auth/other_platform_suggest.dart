import 'package:digital_store_flutter/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class OtherPlatformSuggest extends StatelessWidget {
  const OtherPlatformSuggest({
    Key? key,
    required this.suggestion,
  }) : super(key: key);

  final String suggestion;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const GDivider(),
        const Spacer(),
        Text(
          suggestion,
          style: const TextStyle(
            fontSize: 14,
            height: 1.2,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6A707C),
          ),
        ),
        const Spacer(),
        const GDivider(),
      ],
    );
  }
}
