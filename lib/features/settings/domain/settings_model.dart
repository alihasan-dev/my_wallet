import 'package:flutter/material.dart';

import '../../../constants/app_icons.dart';

class SettingModel {
  SettingItemId id;
  String title;
  String subTitle;
  IconData icon;
  bool showSwitch;
  bool switchValue;
  bool isLauncher;

  SettingModel({
    required this.id,
    this.icon = AppIcons.settingsIcon,
    required this.title,
    this.subTitle = "",
    this.showSwitch = false,
    this.switchValue = false,
    this.isLauncher = false,
  });
}

enum SettingItemId {
  language,
  theme,
  transactionDetails,
  archiveUser,
  biometricToggle,
  webApp,
  currency,
  about
}