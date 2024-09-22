import 'package:flutter/material.dart';
import 'package:my_wallet/features/dashboard/domain/user_model.dart';

sealed class ApperanceState {}

class ApperanceInitialState extends ApperanceState {}

class ApperanceThemeChangeState extends ApperanceState {
  ThemeMode themeMode;

  ApperanceThemeChangeState({required this.themeMode});
}


class ApperanceUserDetailsState extends ApperanceState {
  UserModel userModel;

  ApperanceUserDetailsState({required this.userModel});
}