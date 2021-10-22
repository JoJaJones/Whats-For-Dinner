import 'package:flutter/material.dart';
// import 'package:whats_for_dinner/models/IngredientType.dart';

class TextEntry extends StatelessWidget {
  static Function _defaultValidator = (String? value) => null;
  static var _defaultSaveFunc = (String? value) {};
  String title;
  String? id;
  String? hint;
  // IngredientType data;
  var validatorFunc;
  var saveFunc;
  TextInputType? inputType;

  TextEntry(
      this.title,
      {
        this.id,
        this.hint,
        Function(String?)? validator,
        Function(String?)? saveFunction,
        this.inputType
      })
      : validatorFunc = validator ?? _defaultValidator,
        saveFunc = saveFunction ?? _defaultSaveFunc;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: title,
        hintText: hint,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
        ),
      ),
      validator: validatorFunc,
      onSaved: saveFunc,
    );
  }
}

