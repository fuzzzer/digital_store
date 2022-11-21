import 'package:flutter/material.dart';

extension WidgetListExtension on List<Widget> {
  List<Widget> generateSpacedList() {
    final resultList = <Widget>[];

    if (length > 0) {
      resultList.add(this[0]);
    }

    for (int i = 1; i < length; i++) {
      resultList.add(const Spacer());
      resultList.add(this[i]);
    }

    return resultList;
  }

  List<Widget> convertToPaddedWidgetList({
    double leftPadding = 0,
    double midPadding = 10,
    double rightPadding = 0,
  }) {
    final List<Widget> result = [];

    if (isNotEmpty) {
      result.add(
        Padding(
          padding: EdgeInsets.only(
            left: leftPadding,
          ),
          child: this[0],
        ),
      );
    }

    for (int i = 1; i < length - 1; i++) {
      result.add(
        Padding(
          padding: EdgeInsets.only(left: midPadding),
          child: this[i],
        ),
      );
    }

    if (isNotEmpty) {
      result.add(
        Padding(
          padding: EdgeInsets.fromLTRB(
            length > 1 ? midPadding : 0,
            0,
            rightPadding,
            0,
          ),
          child: this[length - 1],
        ),
      );
    }

    return result;
  }
}
