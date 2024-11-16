import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_wallet/constants/app_images.dart';

class EmptyPage extends StatelessWidget {
  static const double _width = 400;
  const EmptyPage({super.key});
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width, EmptyPage._width) / 2;
    final theme = Theme.of(context);
    return Scaffold(
      // Add invisible appbar to make status bar on Android tablets bright.
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        alignment: Alignment.center,
        child: Image.asset(
          AppImages.appImage,
          color: theme.colorScheme.surfaceContainerHigh,
          width: width,
          height: width,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}