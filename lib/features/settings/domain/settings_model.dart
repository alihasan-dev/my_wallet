import 'package:flutter/material.dart';

class SettingModel {
  String title;
  String subTitle;
  IconData icon;
  bool showSwitch;
  bool switchValue;

  SettingModel({
    this.icon = Icons.settings,
    required this.title,
    this.subTitle = "",
    this.showSwitch = false,
    this.switchValue = false
  });
}