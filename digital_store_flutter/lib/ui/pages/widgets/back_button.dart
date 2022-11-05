import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GBackButton extends StatelessWidget {
  const GBackButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => context.pop(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 41,
            height: 41,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE8ECF4),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF1E232C),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
