import 'package:flutter/material.dart';

class Buttons {
  static Widget getButton(
    String text,
    VoidCallback onPress, {
    Color? fillColor,
    Color? borderColor,
    Color? textColor,
    BoxConstraints constraints = const BoxConstraints(minWidth: 88, minHeight: 36),
  }) {
    return RawMaterialButton(
      onPressed: onPress,
      child: Text(text, style: TextStyle(color: textColor)),
      fillColor: fillColor,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor ?? Colors.transparent),
      ),
    );
  }
}
