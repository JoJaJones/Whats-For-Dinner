import 'package:flutter/material.dart';

class CustomFontStyles {
  static TextStyle bold({required double fontSize, Color? fontColor}) {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize, color: fontColor);
  }

  static TextStyle regular({required double fontSize, Color? fontColor}) {
    return TextStyle(fontSize: fontSize, color: fontColor);
  }
}