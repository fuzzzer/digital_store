import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';

Future<String> fileTobase64(File file) async {
  return base64Encode(await file.readAsBytes());
}

Image? base64ToImage(String base64) {
  try {
    return Image.memory(base64Decode(base64));
  } catch (_) {
    return null;
  }
}
