import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  const CustomImageWidget({
    required this.imageUrl,
    required this.imageSize,
    this.padding = AppSize.s2,
    this.circularPadding = AppSize.s10,
    this.strokeWidth = AppSize.s2,
    this.borderWidth = AppSize.s2,
    this.fromProfile = true,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: imageSize,
      height: imageSize,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryColor, 
          width: borderWidth
        ),
      ),
      child: ClipOval(
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
              )
            : kIsWeb 
              ? Image.memory(base64Decode(imageUrl), fit: BoxFit.cover) 
              : Image.file(File(imageUrl), fit: BoxFit.cover)
        ),
      )
    );
  }

}