import 'package:flutter/material.dart';
import '../utils/preferences.dart';
import '../constants/app_strings.dart';

extension StringExtension on String {

  bool get isBlank {
    return trim().isEmpty ? true : false;
  }

  bool get isNetworkImage {
    if(startsWith('http') || startsWith('https')){
      return true;
    }
    return false;
  }

  bool get isValidEmail {
    var regExp = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return regExp.hasMatch(this);
  }

  Locale get getLocale {
    var data =  this;
    switch (data) {
      case 'Hindi':
        return const Locale('hi','IN');
      default:
        Preferences.setString(key: AppStrings.prefLanguage, value: AppStrings.english);
        return const Locale('en', 'US');
    }
  } 

  ThemeMode get getThemeMode {
    var data = this;
    switch (data) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        Preferences.setString(key: AppStrings.prefTheme, value: 'system');
        return ThemeMode.system;
    }
  }

  String get capitalize {
    try {
      return '${substring(0,1).toUpperCase()}${substring(1)}';
    } catch(e) {
      return this;
    }
  }

  String amountFormat({required String type}) {
    try {
      if(type == 'Transfer') {
        return '- ₹$this'; 
      }
      return '+ ₹$this';
    } catch (e) {
      return '₹${toString()}';
    }
  }
  
}
extension ScreenBuildContext on BuildContext {

  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  double get statusBarHeight => MediaQuery.of(this).padding.top;

}

extension NumberExtension on num {

  String get balanceFormat {
    try {
      if(isNegative) {
        return '- ₹${abs()}'; 
      }
      return '₹${toString()}';
    } catch (e) {
      return '₹${toString()}';
    }
  }
}