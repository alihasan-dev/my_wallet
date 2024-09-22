import 'package:flutter/material.dart';
import '../constants/app_font.dart';
import 'app_size.dart';

TextStyle _getStyle(double fontSize, String fontFamily, FontWeight fontWeight, Color? color) {
  return TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight
  );
}

//regular style
TextStyle getRegularStyle({double fontSize = AppSize.s12, Color? color}) {
  return _getStyle(fontSize, AppFontConstant.fontFamily, AppFontWeight.regular, color);
}

///light style
TextStyle getLightStyle({double fontSize = AppSize.s10, Color? color}) {
  return _getStyle(fontSize, AppFontConstant.fontFamily, AppFontWeight.light, color);
}

///medium style
TextStyle getMediumStyle({double fontSize = AppSize.s14, Color? color}) {
  return _getStyle(fontSize, AppFontConstant.fontFamily, AppFontWeight.medium, color);
}

///semiBold style
TextStyle getSemiBoldStyle({double fontSize = AppSize.s16, Color? color}) {
  return _getStyle(fontSize, AppFontConstant.fontFamily, AppFontWeight.semiBold, color);
}

///bold style
TextStyle getBoldStyle({double fontSize = AppSize.s18, Color? color}) {
  return _getStyle(fontSize, AppFontConstant.fontFamily, AppFontWeight.bold, color);
}