import 'package:flutter/material.dart';
import '../widgets/custom_inkwell_widget.dart';
import '../widgets/custom_text.dart';
import '../constants/app_color.dart';
import '../constants/app_style.dart';
import '../constants/app_size.dart';

class CustomButton extends StatelessWidget {

  final String title;
  final VoidCallback? onTap;
  final Color? buttonColor;
  final Color? titleColor;
  final double? titleSize;
  final double? verticalPadding;

  const CustomButton({
    required this.title,
    this.onTap,
    this.buttonColor,
    this.titleColor,
    this.titleSize,
    this.verticalPadding,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkWellWidget(
      onTap: onTap,
      widget: Ink(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(vertical: verticalPadding ?? AppSize.s12),
        decoration: BoxDecoration(
          color: buttonColor ?? (onTap == null ? AppColors.grey.withOpacity(0.3) : AppColors.primaryColor),
          borderRadius: BorderRadius.circular(AppSize.s4)
        ),
        child: CustomText(
          title: title,
          textAlign: TextAlign.center,
          textStyle: getSemiBoldStyle(
            fontSize: titleSize ?? AppSize.s14, 
            color: titleColor ?? (onTap == null ? AppColors.white.withOpacity(0.6) : AppColors.white)
          ),
        ),
      ),
    );
  }
}