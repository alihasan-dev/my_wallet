import 'dart:io';
import 'package:flutter/material.dart';
import '../domain/left_navigation_icon_title_model.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_size.dart';
import '../../../constants/app_strings.dart';
import '../../../utils/preferences.dart';
import '../../../widgets/custom_text_button.dart';
import '../../../widgets/custom_text.dart';
import '../../../utils/app_extension_method.dart';

class LeftNavigationDrawerScreen extends StatelessWidget {
  
  final Function(int) onPressed;
  final int selectedIndex;

  const LeftNavigationDrawerScreen({
    super.key,
    required this.selectedIndex,
    required this.onPressed
  });

  
  @override
  Widget build(BuildContext context) {

    final drawerList = <LeftNavigationIconTitleModel>[
      LeftNavigationIconTitleModel(icon: AppIcons.dashboardIcon, title: AppStrings.dashboard),
      LeftNavigationIconTitleModel(icon: AppIcons.accountCircleIcon, title: AppStrings.profile),
    ];
    var imageUrl = Preferences.getString(key: AppStrings.prefProfileImg);
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            color: AppColors.primaryColor,
            padding: EdgeInsets.only(
              left: AppSize.s16,
              right: AppSize.s16,
              top: AppSize.s14 + context.statusBarHeight,
              bottom: AppSize.s16
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: AppSize.s1)
                  ),
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(AppSize.s30), // Image radius
                      child: imageUrl.isEmpty
                      ? const Center(child: Icon(AppIcons.personIcon, size: AppSize.s30))
                      : imageUrl.isNetworkImage
                        ? Image.network(
                            imageUrl,
                            loadingBuilder: (context, child, loading){
                            if(loading == null){
                              return child;
                            } else {
                              return const Center(child: CircularProgressIndicator(strokeWidth: AppSize.s2));
                            }
                            }, 
                            fit: BoxFit.cover
                          )
                        : Image.file(File(imageUrl), fit: BoxFit.cover)
                    ),
                  )
                ),
                const SizedBox(height: AppSize.s10),
                CustomText(title: Preferences.getString(key: AppStrings.prefFullName)),
                CustomText(title: Preferences.getString(key: AppStrings.prefEmail))
              ],
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(AppSize.s16),
              children: List.generate(
                drawerList.length, 
                (index) {
                  var data = drawerList[index];
                  return CustomTextButton(
                    onPressed: () => onPressed(index),
                    icon: data.icon,
                    title: data.title,
                    isSelected: selectedIndex == index ? true : false,
                  );
                }
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSize.s16),
            child: CustomTextButton(
              onPressed: () => onPressed(-1),
              icon: AppIcons.logoutIcon,
              title: AppStrings.logout,
              isSelected: true,
              backgroundColor: AppColors.red.withOpacity(0.2),
              foregroundColor: AppColors.red,
              showBorder: true,
            ),
          ),
        ],
      )
    );
  }
}