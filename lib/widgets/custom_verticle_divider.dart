import 'package:flutter/material.dart';
import '../constants/app_color.dart';
import '../constants/app_size.dart';

class CustomVerticalDivider extends StatelessWidget {

  const CustomVerticalDivider({super.key});

  @override
  Widget build(BuildContext context){
    return const VerticalDivider(
      color: AppColors.black, 
      thickness: AppSize.s05,
      width: AppSize.s05
    );
  }
}