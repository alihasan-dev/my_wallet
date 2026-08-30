import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_icons.dart';
import '../constants/app_theme.dart';
import '../l10n/app_localizations.dart';
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
  static int _lastTimestamp = 0;
  static int _counter = 0;

  static List<String> months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  void showSnackBar({
    required BuildContext context, 
    required String title,
    String? message, 
    Color? color
  }) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      padding: EdgeInsets.zero,
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
        side: BorderSide(
          width: 1.0, 
          color: AppColors.grey.withValues(alpha: 0.5)
        ),
      ),
      margin: EdgeInsets.only(
        bottom: AppSize.s20, 
        left: kIsWeb && context.screenWidth.screenDimension == ScreenType.web
        ? context.screenWidth * 0.65  
        : AppSize.s20, 
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
            ? Icon(AppIcons.checkCircleIcon, color: color, size: AppSize.s20)
            : const Icon(
                AppIcons.warningIcon, 
                color: AppColors.amber, 
                size: AppSize.s20
              ),
            const SizedBox(width: AppSize.s10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: title,
                    textStyle: getSemiBoldStyle(
                      fontSize: AppSize.s14, 
                      color: color ?? AppColors.red
                    ),
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
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void showLoadingDialog({required BuildContext context}) {
    if(!isLoadingVisible) {
      isLoadingVisible = true;
      showGeneralDialog(
        context: context, 
        barrierColor: AppColors.transparent,
        barrierDismissible: true,
        barrierLabel: AppStrings.close,
        pageBuilder: (_, a1, _) {
          return ScaleTransition(
            scale: Tween<double>( begin: 0.8, end: 1.0 ).animate(a1),
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
      log(AppStrings.dialogShowingMessage);
    }
  }

  void hideLoadingDialog({required BuildContext context}) {
    if(isLoadingVisible) {
      isLoadingVisible = false;
      context.pop();
    } else {
      log(AppStrings.dialogNotShowingMessage);
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
      pageBuilder: (_, a1, _) => ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(a1),
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
            textStyle: getMediumStyle(
              color: Helper.isDark 
              ? AppColors.white.withValues(alpha: 0.9) 
              : AppColors.black,
              fontSize: AppSize.s16
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s10)),
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

  void showComingSoonDialog({
    required BuildContext context,
    required String title,
    required String description
  }) {
    showGeneralDialog(
      context: context, 
      barrierDismissible: true,
      barrierLabel: AppStrings.close,
      pageBuilder: (context, a1, a2) => ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(a1),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s10)),
          backgroundColor: Helper.isDark ? AppColors.topDarkColor : AppColors.white,
          insetPadding: const EdgeInsets.all(AppSize.s12),
          contentPadding: const EdgeInsets.all(AppSize.s15),
          content: Container(
            width: kIsWeb ? MyAppTheme.columnWidth : (MyAppTheme.columnWidth - AppSize.s40),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSize.s10)),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                Row(
                  children: [
                    Icon(
                      AppIcons.campaignIcon, 
                      size: AppSize.s28,
                      color: AppColors.primaryColor
                    ),
                    const SizedBox(width: AppSize.s5),
                    CustomText(
                      title: title,
                      textStyle: getSemiBoldStyle(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSize.s5),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: CustomText(
                    title: description,
                    textSize: AppSize.s14,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => context.pop(), 
                      child: CustomText(
                        title: "Got it", 
                        textStyle: getSemiBoldStyle(color: AppColors.primaryColor)
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  static List<String> filterTransactionStatusList = [
    AppStrings.all,
    AppStrings.active,
    AppStrings.inactive
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

  static String generateId({String prefix = '', int length = 8}) {
    // if (preffix.isBlank) preffix = AppStrings.appName;
    // const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    // final rnd = Random.secure();
    // final suffix =  List.generate(length, (index) => chars[rnd.nextInt(chars.length)]).join();
    // return '${preffix.substring(0, 3)}-$suffix'.toUpperCase();
    if (prefix.isBlank) prefix = AppStrings.appName;

    // Ensure prefix is at least 3 chars to avoid RangeError
    final safePrefix = prefix.length >= 3
        ? prefix.substring(0, 3)
        : prefix.padRight(3, 'X');

    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rnd = Random.secure();

    // Timestamp component (base36 to keep it short)
    final now = DateTime.now().millisecondsSinceEpoch;

    // Monotonic counter guards against multiple IDs generated in the same millisecond
    if (now == _lastTimestamp) {
      _counter++;
    } else {
      _counter = 0;
      _lastTimestamp = now;
    }

    final timePart = now.toRadixString(36).toUpperCase();
    final counterPart = _counter.toRadixString(36).toUpperCase().padLeft(2, '0');

    // Random component fills remaining length
    final randomLength = (length - timePart.length - counterPart.length).clamp(4, length);
    final randomPart = List.generate(
      randomLength,
      (index) => chars[rnd.nextInt(chars.length)],
    ).join();
    return '$safePrefix-$timePart$counterPart$randomPart'.toUpperCase();
  }

  static String getFormattedDateTime([DateTime? dateTime]) {
    final dt = dateTime ?? DateTime.now();
    
    final day = dt.day.toString().padLeft(2, '0');
    final month = months[dt.month - 1];
    final year = dt.year.toString();
    
    int hour12 = dt.hour % 12;
    if (hour12 == 0) hour12 = 12;
    final hour = hour12.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    
    return '$day $month $year, $hour:$minute $period';
  }

}