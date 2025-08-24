import 'package:flutter/material.dart';

import '../../../constants/app_icons.dart';

class SettingModel {
  String title;
  String subTitle;
  IconData icon;
  bool showSwitch;
  bool switchValue;
  bool isLauncher;

  SettingModel({
    this.icon = AppIcons.settingsIcon,
    required this.title,
    this.subTitle = "",
    this.showSwitch = false,
    this.switchValue = false,
    this.isLauncher = false,
  });
}