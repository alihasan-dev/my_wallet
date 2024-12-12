import 'package:flutter/material.dart';
import '../utils/helper.dart';
import '../constants/app_color.dart';
import '../constants/app_size.dart';
import '../constants/app_style.dart';
import '../widgets/custom_text.dart';

class CustomTextButton extends StatelessWidget {

  final Function()? onPressed;
  final String title;
  final IconData? icon;
  final bool? isSelected;
  final bool? showBorder;
  final bool isShapeStadium;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final MainAxisAlignment? mainAxisAlignment;
  final double verticalPadding;
  final double horizontalPadding;
   

  const CustomTextButton({
    super.key,
    required this.title,
    this.icon,
    this.isSelected,
    this.onPressed,
    this.showBorder,
    this.isShapeStadium = false,
    this.verticalPadding = AppSize.s8,
    this.horizontalPadding = AppSize.s0,
    this.borderColor,
    this.backgroundColor,
    this.foregroundColor,
    this.mainAxisAlignment
  });

  @override
  Widget build(BuildContext context){
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: isShapeStadium
        ? const StadiumBorder()
        : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s4), 
          side: showBorder == null || !showBorder!
          ? BorderSide.none
          : BorderSide(color: borderColor ?? foregroundColor ?? AppColors.red)
        ),
        backgroundColor: isSelected == null || !isSelected! 
        ? AppColors.transparent 
        : backgroundColor ?? AppColors.primaryColor.withOpacity(0.2),
        padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding)
      ), 
      child: Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        children: [
          Visibility(
            visible: icon == null ? false : true,
            child: Row(
              children: [
                Icon(
                 icon, 
                  size: AppSize.s22, 
                  color: isSelected == null || !isSelected! 
                  ? Helper.isDark ? AppColors.grey : AppColors.black 
                  : foregroundColor ?? AppColors.primaryColor
                ),
                const SizedBox(width: AppSize.s14),
              ],
            ),
          ),
          CustomText(
            title: title, 
            textStyle: getMediumStyle(
              color: isSelected == null || !isSelected! 
              ? Helper.isDark ? AppColors.grey : AppColors.black 
              : foregroundColor ?? AppColors.primaryColor
            ),
          ),
        ],
      ),
    );
  }
}