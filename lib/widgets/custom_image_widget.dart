import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_wallet/utils/app_extension_method.dart';
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

  const CustomImageWidget({
    required this.imageUrl,
    required this.imageSize,
    this.padding = AppSize.s2,
    this.circularPadding = AppSize.s10,
    this.strokeWidth = AppSize.s2,
    this.borderWidth = AppSize.s2,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryColor, width: borderWidth)
      ),
      child: ClipOval(
        child: SizedBox.fromSize(
          size: Size.fromRadius(imageSize),
          child: imageUrl.isEmpty
          ? const Center(child: Icon(AppIcons.personIcon, size: AppSize.s60))
          : imageUrl.isNetworkImage
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => Padding(
                  padding: EdgeInsets.all(circularPadding),
                  child: CircularProgressIndicator(strokeWidth: strokeWidth)
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              )
            // ? Image.network(
            //     imageUrl,
            //     loadingBuilder: (context, child, loading){
            //     if(loading == null) {
            //       return child;
            //     } else {
            //       return const Center(child: CircularProgressIndicator(strokeWidth: AppSize.s2));
            //     }
            //     }, 
            //     fit: BoxFit.cover
            //   )
            : Image.file(File(imageUrl), fit: BoxFit.cover)
        ),
      )
    );
  }

}