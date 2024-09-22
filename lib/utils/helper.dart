import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/app_extension_method.dart';
import '../constants/app_strings.dart';
import '../constants/app_color.dart';
import '../constants/app_style.dart';
import '../constants/app_size.dart';
import '../widgets/custom_text.dart';

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
        side: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.5))
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
      showDialog(
        context: context, 
        barrierColor: AppColors.transparent,
        builder: (_) {
          return AlertDialog(
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
                child: const Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
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
    return await showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        backgroundColor: Helper.isDark 
        ? AppColors.dialogColorDark 
        : AppColors.white,
        title: CustomText(
          title: title, textStyle: 
          getBoldStyle(
            color: Helper.isDark 
            ? AppColors.white.withOpacity(0.9) 
            : AppColors.black
          ),
        ),
        content: CustomText(
          title: content, 
          textStyle: getSemiBoldStyle(
            color: Helper.isDark 
            ? AppColors.white.withOpacity(0.9) 
            : AppColors.black
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s6)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: CustomText(
              title: localizations.cancel, 
              textStyle: getSemiBoldStyle(color: AppColors.red)
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: CustomText(
              title: localizations.yes, 
              textStyle: getSemiBoldStyle(color: AppColors.primaryColor)
            ),
          ),
        ],
      )
    ) ?? false;
  }

  ////Transaction Constants
  static List<String> listTransactionType = [
    AppStrings.transfer,
    AppStrings.receive
  ];

}