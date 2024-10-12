import 'package:flutter/material.dart';

class SettingLanguageModel {

  String title;
  String selectedLanguage;
  Locale locale;

  SettingLanguageModel({
    required this.title,
    required this.selectedLanguage,
    required this.locale
  });
}