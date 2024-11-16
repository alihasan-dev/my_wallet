import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/constants/app_images.dart';
import 'package:my_wallet/constants/app_strings.dart';
import 'package:my_wallet/routes/app_routes.dart';
import 'package:my_wallet/utils/preferences.dart';

class InitialRoute extends StatelessWidget {
  const InitialRoute({super.key});

  @override
  Widget build(BuildContext context) {
    initialNavigation(context: context);
    return Center(
      child: Image.asset(AppImages.appImage, width: 400, height: 400),
    );
  }

  Future<void> initialNavigation({required BuildContext context}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if(Preferences.getString(key: AppStrings.prefUserId).isNotEmpty && context.mounted) {
      context.go(AppRoutes.dashboard);
    } else {
      context.go(AppRoutes.loginScreen);
    }
  }
}