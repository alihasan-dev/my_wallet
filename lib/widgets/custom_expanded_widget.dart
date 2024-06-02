import 'package:flutter/material.dart';
import '../widgets/custom_text.dart';
import '../constants/app_color.dart';
import '../constants/app_size.dart';

class CustomExpandedWidget extends StatelessWidget {
  final TextStyle? textStyle;
  final String title;
  final Color? textColor;
  final int? flex;

  const CustomExpandedWidget({
    super.key,
    required this.title, 
    this.textStyle, 
    this.textColor,
    this.flex
  });

  @override
  Widget build(BuildContext context){
    return Expanded(
      flex: flex ?? 1,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.s10, 
          vertical: AppSize.s15
        ),
        color: AppColors.white,
        child: CustomText(
          title: title, 
          textStyle: textStyle
        ),
      ),
    );
  }
}