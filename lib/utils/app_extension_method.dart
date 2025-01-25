import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/helper.dart';
import '../utils/preferences.dart';
import '../constants/app_strings.dart';

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

  String get currencyFormat {
    try {
      final oCcy =  NumberFormat("##,##,##,###", "en_IN");
      return oCcy.format(double.parse(this));
    } catch (e) {
      return this;
    }
  }

  String amountFormat({required String type}) {
    try {
      if(type.isEmpty) return '₹0';
      if(type == 'Transfer') {
        return '- ₹$currencyFormat'; 
      }
      return '+ ₹$currencyFormat';
    } catch (e) {
      return '₹${toString()}';
    }
  }

  String get determineAppVersion {
    try {
      return isNotEmpty 
      ? this 
      : kIsWeb ? 'Web' : 'Unknown';
    } catch (e) {
      return kIsWeb ? 'Web' : 'Unknown';
    }
  }
  
}

extension DateTimeFormator on DateTime {

  String get formatDateTime {
    try {
      return toString().substring(0,10).split('-').reversed.join('-');
    } catch(e) {
      return toString();
    }
  }

  bool campareDateOnly(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
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
        var temp = '${abs()}'.currencyFormat; 
        return '- ₹$temp';
      }
      return '₹${toString().currencyFormat}';
    } catch (e) {
      return '₹${toString().currencyFormat}';
    }
  }

  ScreenType get screenDimension {
    var dimension = this;
    if(dimension < 600) {
      return ScreenType.mobile;
    } else if(dimension >= 600 && dimension <= 720) {
      return ScreenType.tablet;
    } else {
      return ScreenType.web;
    }
  }

}