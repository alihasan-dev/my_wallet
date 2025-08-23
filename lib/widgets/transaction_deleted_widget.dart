import 'package:flutter/material.dart';
import '../constants/app_size.dart';
import '../widgets/custom_text.dart';
import '../constants/app_color.dart';

class TransactionDeletedWidget extends StatelessWidget {

  const TransactionDeletedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.s2, 
        horizontal: AppSize.s5
      ),
      child: CustomText(
        title: 'Deleted',
        textStyle: TextStyle(
          fontStyle: FontStyle.italic,
          color: AppColors.grey,
          fontSize: 13
        ),
      ),
    );
  }
  
}