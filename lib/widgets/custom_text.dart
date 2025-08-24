import 'package:flutter/material.dart';
import '../utils/helper.dart';
import '../constants/app_color.dart';
import '../constants/app_style.dart';
import '../constants/app_size.dart';

class CustomText extends StatelessWidget {
  final String title;
  final Color? textColor;
  final double? textSize;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final int? maxLines;
  final TextOverflow? overflow;

  const CustomText({
    required this.title,
    this.textColor,
    this.textAlign,
    this.textStyle,
    this.textSize,
    this.maxLines,
    this.overflow,
    super.key
  });

  @override
  Widget build(BuildContext context){
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow,
      style: textStyle ?? getRegularStyle(
        fontSize: textSize ?? AppSize.s14,
        color: textColor ?? (Helper.isDark ? AppColors.white : AppColors.black)
      )
    );
  }
}