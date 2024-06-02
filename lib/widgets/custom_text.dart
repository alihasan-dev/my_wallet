import 'package:flutter/material.dart';
import '../../constants/app_color.dart';
import '../../constants/app_style.dart';
import '../constants/app_size.dart';

class CustomText extends StatelessWidget {
  final String title;
  final Color? textColor;
  final double? textSize;
  final TextAlign? textAlign;
  final TextStyle? textStyle;

  const CustomText({
    required this.title,
    this.textColor,
    this.textAlign,
    this.textStyle,
    this.textSize,
    super.key
  });

  @override
  Widget build(BuildContext context){
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      style: textStyle ?? getRegularStyle(
        fontSize: textSize ?? AppSize.s14,
        color: textColor ?? AppColors.white
      ),
    );
  }
}