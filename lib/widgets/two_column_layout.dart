import 'package:flutter/material.dart';
import 'package:my_wallet/constants/app_theme.dart';

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
    final theme = Theme.of(context);

    return ScaffoldMessenger(
      child: Scaffold(
        body: Row(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              width: MyAppTheme.columnWidth + (displayNavigationRail ? MyAppTheme.navRailWidth : 0),
              child: mainView,
            ),
            Container(
              width: 0.5,
              color: theme.dividerColor,
            ),
            Expanded(
              child: ClipRRect(
                child: sideView,
              ),
            ),
          ],
        ),
      ),
    );
  }
}