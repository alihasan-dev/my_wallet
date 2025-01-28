import 'package:flutter/material.dart';
import '../constants/app_color.dart';
import '../constants/app_size.dart';
import '../constants/app_style.dart';
import '../widgets/custom_text.dart';

class CustomOutlinedButton extends StatelessWidget {

  final Function()? onPressed;
  final String title;
  final IconData icon;
  final bool? isSelected;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  const CustomOutlinedButton({
    super.key,
    required this.title,
    required this.icon,
    this.isSelected,
    this.onPressed,
    this.borderColor,
    this.backgroundColor,
    this.foregroundColor
  });

  @override
  Widget build(BuildContext context){
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isSelected == null || !isSelected! 
          ? AppColors.black 
          : borderColor ?? foregroundColor ?? AppColors.primaryColor
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s4)),
        backgroundColor: isSelected == null || !isSelected! 
        ? AppColors.transparent 
        : backgroundColor ?? AppColors.primaryColor.withValues(alpha: 0.2),
        padding: const EdgeInsets.symmetric(vertical: AppSize.s12)
      ), 
      child: CustomText(
        title: title, 
        textStyle: getMediumStyle(
          color: isSelected == null || !isSelected! 
          ? AppColors.black 
          : foregroundColor ?? AppColors.primaryColor
        ),
      ),
    );
  }
}