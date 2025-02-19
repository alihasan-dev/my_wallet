import 'package:flutter/material.dart';
import 'package:my_wallet/constants/app_color.dart';
import 'package:my_wallet/constants/app_size.dart';
import 'package:my_wallet/widgets/custom_image_widget.dart';
import 'package:my_wallet/widgets/custom_text.dart';
import '../constants/app_images.dart';

class GoogleSigninCustomButton extends StatelessWidget {
  
  final VoidCallback? onTap;

  const GoogleSigninCustomButton({
    this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.s5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s5),
          border: Border.all(color: AppColors.grey.withValues(alpha: 0.4))
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSize.s12),
        child: Row(
          spacing: AppSize.s10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageWidget(
              imageUrl: AppImages.googleIcon, 
              imageSize: AppSize.s22,
              strokeWidth: AppSize.s0,
              borderWidth: AppSize.s0,
              padding: AppSize.s0,
              borderColor: AppColors.transparent,
            ),
            CustomText(title: 'Continue with Google')
          ],
        ),
      ),
    );
  }
}