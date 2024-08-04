import 'package:flutter/material.dart';
import '../constants/app_color.dart';
import '../constants/app_size.dart';

class CustomCheckBoxWidget extends StatelessWidget {

  final Function(bool?)? onChange;
  final bool value;
  final double? padding;

  const CustomCheckBoxWidget({
    super.key,
    required this.value,
    required this.onChange,
    this.padding
  });

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: padding ?? AppSize.s20,
      height: padding ?? AppSize.s20,
      child: Checkbox(
        activeColor: AppColors.primaryColor,
        checkColor: AppColors.white,
        value: value, 
        onChanged: onChange
      ),
    );
  }
}