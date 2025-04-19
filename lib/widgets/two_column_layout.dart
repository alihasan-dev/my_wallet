import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants/app_color.dart';
import '../utils/app_extension_method.dart';
import '../utils/helper.dart';
import '../constants/app_theme.dart';

class TwoColumnLayout extends StatelessWidget {
  final Widget mainView;
  final Widget sideView;
  final bool displayNavigationRail;

  const TwoColumnLayout({
    super.key,
    required this.mainView,
    required this.sideView,
    required this.displayNavigationRail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, elevation: 0),
      body: Row(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(),
            width: MyAppTheme.columnWidth + (displayNavigationRail ? MyAppTheme.navRailWidth : 0),
            child: mainView,
          ),
          Container(
            width: 0.05,
            color: kIsWeb && context.screenWidth.screenDimension == ScreenType.web
            ?AppColors.grey
            :AppColors.transparent,
          ),
          Expanded(
            child: sideView,
          ),
        ],
      ),
    );
  }
  
}