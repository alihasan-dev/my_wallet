import 'package:flutter/material.dart';

extension StringExtension on String {

  bool get isBlank {
    return trim().isEmpty ? true : false;
  }

  bool get isNetworkImage {
    if(startsWith('http') || startsWith('https')) {
      return true;
    }
    return false;
  }

  bool get isValidEmail {
    var regExp = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return regExp.hasMatch(this);
  }
}

extension ScreenBuildContext on BuildContext {

  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  double get statusBarHeight => MediaQuery.of(this).padding.top;

}