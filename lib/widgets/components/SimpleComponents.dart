import 'package:flutter/material.dart';
import 'package:whats_for_dinner/themes/CustomFontStyles.dart';

class TitleText extends StatelessWidget {
  final double fontSize;
  final String contents;
  final Color? color;

  TitleText(this.contents, {this.fontSize = 15.0, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(contents, style: CustomFontStyles.bold(fontSize: fontSize, fontColor: color),);
  }
}

class ContentText extends StatelessWidget {
  final double fontSize;
  final String contents;
  final Color? color;


  ContentText(this.contents, {this.fontSize = 15.0, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(contents, style: CustomFontStyles.regular(fontSize: fontSize, fontColor: color),);
  }
}