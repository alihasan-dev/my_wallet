import 'dart:convert';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_wallet/constants/app_theme.dart';
import '../utils/app_extension_method.dart';
import '../constants/app_color.dart';
import '../constants/app_icons.dart';
import '../constants/app_size.dart';

class CustomImageWidget extends StatelessWidget {

  final String imageUrl;
  final double imageSize;
  final double circularPadding;
  final double strokeWidth;
  final double padding;
  final double borderWidth;
  final bool fromProfile;
  final bool isSelected;
  final Color borderColor;

  const CustomImageWidget({
    required this.imageUrl,
    required this.imageSize,
    this.padding = AppSize.s2,
    this.circularPadding = AppSize.s10,
    this.strokeWidth = AppSize.s2,
    this.borderWidth = AppSize.s2,
    this.fromProfile = true,
    this.isSelected = false,
    this.borderColor = AppColors.primaryColor,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: MyAppTheme.animationDuration * 2,
      width: imageSize,
      height: imageSize,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primaryColor : null,
        border: Border.all(
          color: borderColor,
          width: borderWidth
        ),
      ),
      child: isSelected
      ? const Icon(Icons.check, color: AppColors.white)
      : ClipOval(
        child: SizedBox.fromSize(
          size: Size.fromRadius(imageSize),
          child: imageUrl.isEmpty
          ? Center(
              child: Icon(
                AppIcons.personIcon,
                size: fromProfile ? AppSize.s60 : AppSize.s30
              ),
            )
          : imageUrl.isNetworkImage
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => Padding(
                  padding: EdgeInsets.all(circularPadding),
                  child: CircularProgressIndicator.adaptive(strokeWidth: strokeWidth)
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
                imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet
              )
            : imageUrl.startsWith('assets/')
              ? Image.asset(imageUrl, fit: BoxFit.cover)
              : Image.memory(base64Decode(imageUrl), fit: BoxFit.cover)
        ),
      )
    );
  }

}