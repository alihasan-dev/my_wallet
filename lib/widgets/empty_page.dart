import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_wallet/constants/app_images.dart';
import 'package:my_wallet/constants/app_size.dart';
import 'package:my_wallet/widgets/custom_text.dart';
import '../constants/app_color.dart';

class EmptyPage extends StatelessWidget {
  static const double _width = 300;
  const EmptyPage({super.key});
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width, EmptyPage._width) / 2;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.appImage,
              width: width,
              height: width,
              filterQuality: FilterQuality.high,
            ),
            CustomText(
              title: "Design & Develop by Traversal", 
              textColor: AppColors.grey.withOpacity(0.5), 
              textSize: AppSize.s12
            ),
          ],
        ),
      ),
    );
  }
}