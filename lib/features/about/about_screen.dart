import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_theme.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_images.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_style.dart';
import '../../utils/helper.dart';
import '../../constants/app_color.dart';
import '../../constants/app_size.dart';
import '../../widgets/custom_text.dart';

class AboutScreen extends StatelessWidget {

  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s10)),
      backgroundColor: Helper.isDark ? AppColors.backgroundColorDark : AppColors.white,
      insetPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(AppSize.s15),
      content: Container(
        width: kIsWeb ? MyAppTheme.columnWidth : (MyAppTheme.columnWidth - AppSize.s40),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSize.s10)),
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [
                Image.asset(
                  AppImages.appImage,
                  width: AppSize.s38,
                  height: AppSize.s38
                ),
                const SizedBox(width: AppSize.s2),
                CustomText(
                  title: AppStrings.appName,
                  textStyle: getSemiBoldStyle(),
                ),
              ],
            ),
            const SizedBox(height: AppSize.s5),
            const CustomText(
              title: '  Version 1.0.0',
              textSize: AppSize.s12,
            ),
            const CustomText(
              title: '  \u00a9 2024 Traversal Inc.',
              textSize: AppSize.s12,
            ),
            InkWell(
              onTap: null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSize.s12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      title: '  Terms & Privacy Policy', 
                      textSize: AppSize.s14
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => launchPolicyUrl(context: context),
                      icon: const Icon(
                        AppIcons.openInNewIcon,
                        size: AppSize.s20,
                        color: AppColors.grey
                      )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  Future<void> launchPolicyUrl({required BuildContext context}) async {
    final Uri uri = Uri.parse(AppStrings.privacyPolicyUrl);
    if(await launchUrl(uri) && context.mounted) {
      context.pop();
    }
  }
}