import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/utils/app_extension_method.dart';
import '../../about/about_screen.dart';
import 'bloc/settings_bloc.dart';
import '../domain/settings_language_model.dart';
import '../domain/settings_model.dart';
import '../domain/settings_theme_model.dart';
import '../../../constants/app_icons.dart';
import '../../my_app/presentation/bloc/my_app_bloc.dart';
import '../../my_app/presentation/bloc/my_app_event.dart';
import '../../../utils/helper.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_style.dart';
import '../../../constants/app_strings.dart';
import '../../../utils/preferences.dart';
import '../../../widgets/custom_text.dart';
import '../../../constants/app_size.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  var settingItemList = <SettingModel>[];
  var themeModeList = <SettingThemeModel>[];
  var languageList = <SettingLanguageModel>[];
  AppLocalizations? _localizations;
  bool showUnverified = false;
  late SettingsBloc _settingBloc;

  @override
  void didChangeDependencies() {
    _settingBloc = context.read<SettingsBloc>();
    _localizations = AppLocalizations.of(context)!;
    themeModeList.clear();
    themeModeList.add(SettingThemeModel(title: _localizations!.systemDefault, theme: "system", themeMode: ThemeMode.system));
    themeModeList.add(SettingThemeModel(title: _localizations!.light, theme: "light", themeMode: ThemeMode.light));
    themeModeList.add(SettingThemeModel(title: _localizations!.dark, theme: "dark", themeMode: ThemeMode.dark));
    languageList.clear();
    languageList.add(SettingLanguageModel(title: AppStrings.english, selectedLanguage:  AppStrings.english, locale: const Locale('en','US')));
    languageList.add(SettingLanguageModel(title: "हिंदी", selectedLanguage:  AppStrings.hindi, locale: const Locale('hi','IN')));
    settingItemList.clear();
    settingItemList.add(SettingModel(icon: Icons.language_outlined, title: _localizations!.language, subTitle: Preferences.getString(key: AppStrings.prefLanguage)));
    settingItemList.add(SettingModel(icon: Icons.contrast_outlined, title: _localizations!.theme, subTitle: Preferences.getString(key: AppStrings.prefTheme)));
    settingItemList.add(SettingModel(icon: Icons.verified_outlined, title: _localizations!.showUnverifiedUser, showSwitch: true));
    settingItemList.add(SettingModel(icon: Icons.fingerprint, title: 'Enable Biometric', subTitle: 'App unlock with biometric', showSwitch: true));
    settingItemList.add(SettingModel(icon: Icons.info_outline_rounded, title: 'About MyWallet'));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext bContent) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          title: _localizations!.settings, 
          textStyle: getBoldStyle(color: AppColors.white)
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.primaryColor
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          switch (state) {
            case SettingsUserDetailsState _:
              showUnverified = state.userModel.isUserVerified;
              settingItemList[2].switchValue = state.userModel.isUserVerified;
              settingItemList[3].switchValue = state.userModel.enableBiometric;
              settingItemList[2].subTitle = state.userModel.isUserVerified ? _localizations!.yes : _localizations!.no;
              settingItemList[1].subTitle = Preferences.getString(key: AppStrings.prefTheme);
              break;
            default:
          }
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: List.generate(
              settingItemList.length, 
              (index) {
                var data = settingItemList[index];
                return InkWell(
                  onTap: data.showSwitch
                  ? null
                  : () => onClickItem(context: context, index: index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.s20,
                      vertical: AppSize.s15
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(data.icon, color: AppColors.grey),
                            const SizedBox(width: AppSize.s12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  title: data.title, 
                                  textStyle: getMediumStyle(
                                    color: Helper.isDark 
                                    ? AppColors.white 
                                    : AppColors.black
                                  ),
                                ),
                                Visibility(
                                  visible: data.subTitle.isNotEmpty,
                                  child: CustomText(
                                    title: data.subTitle.capitalize, 
                                    textColor: AppColors.grey
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Visibility(
                          visible: data.showSwitch,
                          child: Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              value: data.switchValue, 
                              onChanged: (value) => onChangeSwith(index: index, value: value)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
          );
        }
      ),
    );
  }

  void onChangeSwith({required int index, required bool value}) {
    switch (index) {
      case 2:
        context.read<SettingsBloc>().add(SettingsOnChangeVerifiedEvent(isVerified: value));
        break;
      case 3: 
        context.read<SettingsBloc>().add(SettingsOnChangeBiometricEvent(enableBiometric: value));
        break;
      default:
    }
  }

  void onClickItem({required BuildContext context, required int index}) {
    switch (index) {
      case 0:
        showLanguageDialog(context: context);
        break;
      case 1:
        showThemeDialog(context: context);
        break;
      case 4:
        showAboutAppDialog(context: context);
        break;
      default:
    }
  }

  void showAboutAppDialog({required BuildContext context}) {
    showDialog(
      context: context, 
      builder: (context) => const AboutScreen()
    );
  }

  void showThemeDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
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
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSize.s12, vertical: AppSize.s12),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              themeModeList.length,
              (index) {
                var data = themeModeList[index];
                return InkWell(
                  onTap: () { 
                    context.read<MyAppBloc>().add(MyAppChangeThemeEvent(themeMode: data.themeMode));
                    _settingBloc.add(SettingsUserDetailsEvent());
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

  void showLanguageDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
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
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSize.s12, vertical: AppSize.s12),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              languageList.length,
              (index) {
                var data = languageList[index];
                return InkWell(
                  onTap: () { 
                    context.read<MyAppBloc>().add(MyAppChangeLanguageEvent(locale: data.locale));
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
