import 'package:flutter/material.dart';

class SettingModel {
  String title;
  String subTitle;
  IconData icon;

  SettingModel({
    this.icon = Icons.settings,
    required this.title,
    this.subTitle = ""
  });
}