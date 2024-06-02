import 'package:flutter/material.dart';
import '../widgets/custom_inkwell_widget.dart';
import '../widgets/custom_text.dart';
import '../constants/app_color.dart';
import '../constants/app_style.dart';
import '../constants/app_size.dart';

class CustomButton extends StatelessWidget {

  final String title;
  final VoidCallback onTap;
  final Color? buttonColor;
  final Color? titleColor;
  final double? titleSize;

  const CustomButton({
    required this.title,
    required this.onTap,
    this.buttonColor,
    this.titleColor,
    this.titleSize,
    super.key
  });

  @override
  Widget build(BuildContext context){
    return CustomInkWellWidget(
      onTap: onTap,
      widget: Ink(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: AppSize.s12),
        decoration: BoxDecoration(
          color: buttonColor ?? AppColors.primaryColor,
          borderRadius: BorderRadius.circular(AppSize.s4)
        ),
        child: CustomText(
          title: title,
          textAlign: TextAlign.center,
          textStyle: getSemiBoldStyle(
            fontSize: titleSize ?? AppSize.s14, 
            color: titleColor ?? AppColors.white
          ),
        ),
      ),
    );
  }
}