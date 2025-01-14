import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/app_extension_method.dart';
import '../constants/app_strings.dart';
import '../constants/app_color.dart';
import '../constants/app_style.dart';
import '../constants/app_size.dart';
import '../widgets/custom_text.dart';

enum ScreenType {
  mobile,
  tablet,
  web
}

mixin Helper {

  bool isLoadingVisible = false;
  static bool isDark = false;

  void showSnackBar({
    required BuildContext context, 
    required String title,
    String? message, 
    Color? color
  }) {
    var snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      padding: EdgeInsets.zero,
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
        side: BorderSide(width: 1.0, color: Colors.grey.withValues(alpha: 0.5))
      ),
      margin: EdgeInsets.only(
        bottom: AppSize.s20, 
        left: kIsWeb ? context.screenWidth * 0.65 : AppSize.s20, 
        right: AppSize.s20
      ),
      content: Container(
        padding: const EdgeInsets.all(AppSize.s14),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s6))
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            color != null
            ? Icon(Icons.check_circle, color: color, size: AppSize.s20)
            : const Icon(Icons.warning, color: AppColors.amber, size: AppSize.s20),
            const SizedBox(width: AppSize.s10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: title,
                    textStyle: getSemiBoldStyle(fontSize: AppSize.s14, color: color ?? AppColors.red),
                  ),
                  Visibility(
                    visible: message != null,
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppSize.s2),
                      child: CustomText(
                        title: message ?? AppStrings.emptyString,
                        textStyle: getRegularStyle(
                          fontSize: AppSize.s12, 
                          color: AppColors.black
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showLoadingDialog({required BuildContext context}) {
    if(!isLoadingVisible) {
      isLoadingVisible = true;
      showGeneralDialog(
        context: context, 
        barrierColor: AppColors.transparent,
        barrierDismissible: true,
        barrierLabel: AppStrings.close,
        pageBuilder: (_, a1, __) {
          return ScaleTransition(
            scale: Tween<double>( begin: 0.5, end: 1.0 ).animate(a1),
            child: AlertDialog(
              elevation: 0.0,
              contentPadding: EdgeInsets.zero,
              insetPadding: EdgeInsets.zero,
              backgroundColor: AppColors.transparent,
              content: SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 2.5,sigmaY: 2.5,
                  ),
                  child: const Center(child: CircularProgressIndicator.adaptive()),
                ),
              ),
            ),
          );
        },
      );
    } else {
      debugPrint(AppStrings.dialogShowingMessage);
    }
  }

  void hideLoadingDialog({required BuildContext context}) {
    if(isLoadingVisible) {
      isLoadingVisible = false;
      context.pop();
    } else {
      debugPrint(AppStrings.dialogNotShowingMessage);
    }
  }

  Future<bool> confirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required AppLocalizations localizations
  }) async {
    return await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: AppStrings.close,
      pageBuilder: (_, a1, __) => ScaleTransition(
        scale: Tween<double>( begin: 0.5, end: 1.0 ).animate(a1),
        child: AlertDialog(
          backgroundColor: Helper.isDark 
          ? AppColors.dialogColorDark 
          : AppColors.white,
          title: CustomText(
            title: title, textStyle: 
            getBoldStyle(
              color: Helper.isDark 
              ? AppColors.white.withValues(alpha: 0.9) 
              : AppColors.black
            ),
          ),
          content: CustomText(
            title: content, 
            textStyle: getSemiBoldStyle(
              color: Helper.isDark 
              ? AppColors.white.withValues(alpha: 0.9) 
              : AppColors.black
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s6)),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: CustomText(
                title: localizations.cancel, 
                textStyle: getSemiBoldStyle(color: AppColors.red)
              ),
            ),
            TextButton(
              onPressed: () => context.pop(true), 
              child: CustomText(
                title: localizations.yes, 
                textStyle: getSemiBoldStyle(color: AppColors.primaryColor)
              ),
            ),
          ],
        ),
      )
    ) ?? false;
  }

  ////Transaction Constants
  static List<String> listTransactionType = [
    AppStrings.transfer,
    AppStrings.receive
  ];

  static List<String> filterTransactionTypeList = [
    AppStrings.all,
    AppStrings.transfer,
    AppStrings.receive
  ];

  bool compareProfileMap(Map<String, dynamic> firstMap, Map<String, dynamic> secondMap) {
    if(firstMap['profile_img'] ==
    secondMap['profile_img'] &&
    firstMap['address'] ==
    secondMap['address'] &&
    firstMap['phone'] ==
    secondMap['phone'] &&
    firstMap['user_id'] ==
    secondMap['user_id'] &&
    firstMap['name'] ==
    secondMap['name'] &&
    firstMap['email'] ==
    secondMap['email']) {
      return false;
    }
    return true;
  }

  Future<String> pickImage({required ImageSource imageSource, required BuildContext context}) async {
    try {
      var pickImage = await ImagePicker().pickImage(source: imageSource);
      if(pickImage != null) {
        final imageLength = await pickImage.length();
        if(imageLength > 2000000 && context.mounted) {
          showSnackBar(context: context, title: AppStrings.error, message: AppStrings.imageSizeMsg);
          return AppStrings.emptyString;
        }
        return base64Encode(await pickImage.readAsBytes());
      } else {
        return AppStrings.emptyString;
      }
    } catch (e) {
      return AppStrings.emptyString;
    }
  }

}