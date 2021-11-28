import 'package:flutter/material.dart';

class CustomFontStyles {
  static TextStyle bold({required double fontSize}) {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize);
  }

  static TextStyle regular({required double fontSize, Color? fontColor}) {
    return TextStyle(fontSize: fontSize, color: fontColor);
  }
}