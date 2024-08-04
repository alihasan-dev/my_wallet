import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../home/application/bloc/home_bloc.dart';
import '../domain/appearance_theme_model.dart';
import '../domain/apperance_language_model.dart';
import '../../../features/appearance/application/bloc/appearance_bloc.dart';
import '../../../constants/app_icons.dart';
import '../../../features/my_app/presentation/bloc/my_app_bloc.dart';
import '../../../utils/helper.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_style.dart';
import '../../../utils/app_extension_method.dart';
import '../../../constants/app_strings.dart';
import '../../../features/appearance/domain/appearance_model.dart';
import '../../../utils/preferences.dart';
import '../../../widgets/custom_text.dart';
import '../../../constants/app_size.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {

  var appearanceItemList = <AppearanceModel>[];
  var themeModeList = <AppearanceThemeModel>[];
  var languageList = <ApperanceLanguageModel>[];
  AppLocalizations? _localizations;

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context)!;
    themeModeList.clear();
    themeModeList.add(AppearanceThemeModel(title: _localizations!.systemDefault, theme: "system", themeMode: ThemeMode.system));
    themeModeList.add(AppearanceThemeModel(title: _localizations!.light, theme: "light", themeMode: ThemeMode.light));
    themeModeList.add(AppearanceThemeModel(title: _localizations!.dark, theme: "dark", themeMode: ThemeMode.dark));

    languageList.clear();
    languageList.add(ApperanceLanguageModel(title: AppStrings.english, selectedLanguage:  AppStrings.english, locale: const Locale('en','US')));
    languageList.add(ApperanceLanguageModel(title: "हिंदी", selectedLanguage:  AppStrings.hindi, locale: const Locale('hi','IN')));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ApperanceBloc(),
      child: Builder(
        builder: (context) {
          return BlocBuilder<ApperanceBloc, ApperanceState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case ApperanceThemeChangeState:
                  state = state as ApperanceThemeChangeState;
                  context.read<HomeBloc>().add(HomeDrawerItemEvent(index: 2));
                  break;
                default:
              }
              appearanceItemList.clear();
              appearanceItemList.add(AppearanceModel(title: _localizations!.language, subTitle: Preferences.getString(key: AppStrings.prefLanguage)));
              appearanceItemList.add(AppearanceModel(title: _localizations!.theme, subTitle: Preferences.getString(key: AppStrings.prefTheme)));
              return ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: AppSize.s8),
                children: List.generate(
                  appearanceItemList.length, 
                  (index) {
                    var data = appearanceItemList[index];
                    return InkWell(
                      onTap: () => onClickItem(context: context, index: index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.s20,
                          vertical: AppSize.s15
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              title: data.title, 
                              textStyle: getMediumStyle(
                                fontSize: AppSize.s16,
                                color: Helper.isDark 
                                ? AppColors.white 
                                : AppColors.black
                              ),
                            ),
                            CustomText(
                              title: data.subTitle.capitalize, 
                              textColor: AppColors.grey
                            )
                          ],
                        ),
                      ),
                    );
                  }
                ),
              );
            }
          );
        }
      ),
    );
  }

  void onClickItem({required BuildContext context, required int index}){
    switch (index) {
      case 0:
        showLanguageDialog(context: context);
        break;
      case 1:
        showThemeDialog(context: context);
        break;
      default:
    }
  }

  void showThemeDialog({required BuildContext context}){
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog.adaptive(
          title: CustomText(
            title: _localizations!.theme,
            textStyle: getMediumStyle(
              color: Helper.isDark ? AppColors.white.withOpacity(0.9) : AppColors.black,
              fontSize: AppSize.s18
            ),
          ),
          backgroundColor: Helper.isDark 
          ? AppColors.dialogColorDark 
          : AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s6)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: AppSize.s12),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              themeModeList.length,
              (index) {
                var data = themeModeList[index];
                return InkWell(
                  onTap: () { 
                    BlocProvider.of<MyAppBloc>(context).add(MyAppChangeThemeEvent(themeMode: data.themeMode));
                    context.pop();
                    Future.delayed(const Duration(milliseconds: 500), () => context.read<ApperanceBloc>().add(ApperanceChangeThemeEvent(themeMode: data.themeMode)));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.s8,
                      vertical: AppSize.s8
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Preferences.getString(key: AppStrings.prefTheme) == data.theme ? AppIcons.checkIcon : AppIcons.uncheckIcon,
                          color: Preferences.getString(key: AppStrings.prefTheme) == data.theme 
                          ? AppColors.primaryColor
                          : AppColors.grey
                        ),
                        const SizedBox(width: AppSize.s10),
                        CustomText(
                          title: data.title,
                          textStyle: getRegularStyle(
                            color: Helper.isDark ? AppColors.white.withOpacity(0.9) : AppColors.black,
                            fontSize: AppSize.s14
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
        );
      }
    );
  }

  void showLanguageDialog({required BuildContext context}){
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog.adaptive(
          title: CustomText(
            title: _localizations!.language,
            textStyle: getMediumStyle(
              color: Helper.isDark ? AppColors.white.withOpacity(0.9) : AppColors.black,
              fontSize: AppSize.s18
            ),
          ),
          backgroundColor: Helper.isDark 
          ? AppColors.dialogColorDark 
          : AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s6)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: AppSize.s12),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              languageList.length,
              (index) {
                var data = languageList[index];
                return InkWell(
                  onTap: () { 
                    BlocProvider.of<MyAppBloc>(context).add(MyAppChangeLanguageEvent(locale: data.locale));
                    context.pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.s8,
                      vertical: AppSize.s8
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Preferences.getString(key: AppStrings.prefLanguage) == data.selectedLanguage 
                          ? AppIcons.checkIcon 
                          : AppIcons.uncheckIcon,
                          color: Preferences.getString(key: AppStrings.prefLanguage) == data.selectedLanguage 
                          ? AppColors.primaryColor
                          : AppColors.grey
                        ),
                        const SizedBox(width: AppSize.s10),
                        CustomText(
                          title: data.title,
                          textStyle: getRegularStyle(
                            color: Helper.isDark ? AppColors.white.withOpacity(0.9) : AppColors.black,
                            fontSize: AppSize.s14
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
        );
      }
    );
  }

}
