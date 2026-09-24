import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/features/settings/application/transaction_mode_dialog.dart';
import 'package:sample_formatter/sample_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/app_theme.dart';
import '../../../core/analytics/analytics_events.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../features/settings/application/bloc/settings_bloc.dart';
import '../../../utils/app_extension_method.dart';
import '../../../widgets/currency_dialog_view.dart';
import '../../about/about_screen.dart';
import '../domain/setting_dashboard_transaction_mode_model.dart';
import '../domain/settings_language_model.dart';
import '../domain/settings_model.dart';
import '../domain/settings_theme_model.dart';
import '../../../constants/app_icons.dart';
import '../../my_app/presentation/bloc/my_app_bloc.dart';
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
  var dashboardTransactionModeList = <SettingDashboardAmountModeModel>[];
  var languageList = <SettingLanguageModel>[];
  AppLocalizations? _localizations;
  late SettingsBloc _settingBloc;
  CurrencyModel? currencyModel;

  @override
  void initState() {
    currencyModel = CurrencyModel(countryCode: "IN");
    super.initState();
  }

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
    dashboardTransactionModeList.clear();
    dashboardTransactionModeList.add(SettingDashboardAmountModeModel(title: _localizations!.latest_transaction, subtitle:  _localizations!.latest_transaction_msg, mode: DashboardAmountMode.latestTransaction));
    dashboardTransactionModeList.add(SettingDashboardAmountModeModel(title: _localizations!.total_outstanding, subtitle:  _localizations!.total_outstanding_msg, mode: DashboardAmountMode.totalOutstanding));
    settingItemList.clear();
    settingItemList.add(SettingModel(id: SettingItemId.language, icon: AppIcons.languageIcon, title: _localizations!.language, subTitle: Preferences.getString(key: AppStrings.prefLanguage)));
    settingItemList.add(SettingModel(id: SettingItemId.theme, icon: AppIcons.themeModeIcon, title: _localizations!.appearance, subTitle: Preferences.getString(key: AppStrings.prefTheme)));
    settingItemList.add(SettingModel(id: SettingItemId.dashboardTransactionMode, icon: AppIcons.swaphorizIcon, title: _localizations!.transaction_mode, subTitle: DashboardAmountModeExtension.label()));
    settingItemList.add(SettingModel(id: SettingItemId.transactionDetails, icon: AppIcons.barChartIcon, title: _localizations!.transactionBreakdown, subTitle: _localizations!.transactionBreakdownMsg, showSwitch: true));
    settingItemList.add(SettingModel(id: SettingItemId.transactionDescription, icon: AppIcons.description, title: _localizations!.transactionDescription, subTitle: _localizations!.transactionDescriptionMsg, showSwitch: true));
    settingItemList.add(SettingModel(id: SettingItemId.archiveUser, icon: AppIcons.verifiedIcon, title: _localizations!.show_archived_friends, subTitle: _localizations!.show_archived_friends_msg, showSwitch: true));
    if(!kIsWeb) {
      settingItemList.add(SettingModel(id: SettingItemId.biometricToggle, icon: AppIcons.fingerprintIcon, title: _localizations!.enableBiometric, subTitle: _localizations!.enableBiometricMsg, showSwitch: true));
      settingItemList.add(SettingModel(id: SettingItemId.webApp, icon: AppIcons.adsClickIcon, title: _localizations!.openAppOnBrowser, subTitle: AppStrings.webUrl, isLauncher: true));
    }
    // settingItemList.add(SettingModel(id: SettingItemId.currency, icon: AppIcons.currencyIcon, title: "Currency"));
    settingItemList.add(SettingModel(id: SettingItemId.about, icon: AppIcons.infoIcon, title: _localizations!.aboutMyWallet));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext bContent) {
    return Scaffold(
      backgroundColor: Helper.isDark 
      ? AppColors.backgroundColorDark
      : AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
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
              for (final item in settingItemList) {
                switch (item.id) {
                  case SettingItemId.theme:
                    item.subTitle = Preferences.getString(key: AppStrings.prefTheme);
                    break;
                  case SettingItemId.transactionDetails:
                    item.switchValue = state.userModel.showTransactionDetails;
                    break;
                  case SettingItemId.transactionDescription:
                    item.switchValue = state.userModel.showTransactionDescription;
                    break;
                  case SettingItemId.archiveUser:
                    item.switchValue = state.userModel.isUserVerified;
                    break;
                  case SettingItemId.biometricToggle:
                    item.switchValue = state.userModel.enableBiometric;
                  case SettingItemId.dashboardTransactionMode:
                    item.subTitle = DashboardAmountModeExtension.label();
                  default:
                }
              }
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
                  onTap: () => onTapOption(data: data, index: index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.s20,
                      vertical: AppSize.s15
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(data.icon, color: AppColors.primaryColor),
                              const SizedBox(width: AppSize.s12),
                              Expanded(
                                child: Column(
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
                                        title: data.isLauncher
                                        ? data.subTitle
                                        : data.subTitle.capitalize, 
                                        textColor: AppColors.grey
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (data.isLauncher)
                          IconButton(
                            onPressed: launchPolicyUrl,
                            icon: Icon(
                              AppIcons.openInNewIcon,
                              size: AppSize.s20,
                              color: Helper.isDark
                              ? AppColors.white
                              : AppColors.black
                            ),
                          ),
                        if (data.showSwitch)
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              value: data.switchValue, 
                              activeTrackColor: AppColors.primaryColor,
                              onChanged: (value) => onChangeSwith(id: data.id, value: value)
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

  void onTapOption({required SettingModel data, required int index}) {
    if(data.showSwitch || data.isLauncher) {
      if(data.showSwitch) onChangeSwith(id: data.id, value: !data.switchValue);
      if(data.isLauncher) launchPolicyUrl();
    } else {
      switch (data.id) {
        case SettingItemId.language:
          showLanguageDialog(context: context);
          break;
        case SettingItemId.theme:
          showThemeDialog(context: context);
          break;
        case SettingItemId.currency:
          showCurrencyDialog(context: context);
          break;
        case SettingItemId.about:
          showAboutAppDialog(context: context);
          break;
        case SettingItemId.dashboardTransactionMode:
          showDashboardTransactionModeDialog(context: context);
          break;
        default:
      }
    }
  }

  void onChangeSwith({required SettingItemId id, required bool value}) {
    switch (id) {
      case SettingItemId.transactionDetails:
        _settingBloc.add(SettingsOnChangeTransactionDetailsEvent(isEnable: value));
        break;
      case SettingItemId.archiveUser:
        _settingBloc.add(SettingsOnChangeVerifiedEvent(isVerified: value));
        break;
      case SettingItemId.biometricToggle: 
        _settingBloc.add(SettingsOnChangeBiometricEvent(enableBiometric: value));
        break;
      case SettingItemId.transactionDescription: 
        _settingBloc.add(SettingsOnChangeTransactionDescriptionEvent(isEnable: value));
        break;
      default:
    }
  }

  Future<void> launchPolicyUrl() async {
    final Uri uri = Uri.parse(AppStrings.webUrl);
    await launchUrl(uri);
    AnalyticsService.instance.logEvent(
      name: 'screen_view',
      parameters: {'screen_name': 'app_web_view'},
    );
  }

  void showAboutAppDialog({required BuildContext context}) {
    showGeneralDialog(
      context: context, 
      barrierDismissible: true,
      barrierLabel: AppStrings.close,
      pageBuilder: (_, a1, _) => ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(a1),
        child: const AboutScreen()
      ),
    );
  }

  void showCurrencyDialog({required BuildContext context}) {
    showGeneralDialog(
      context: context, 
      barrierDismissible: true,
      barrierLabel: AppStrings.close,
      pageBuilder: (_, a1, _) => CurrencyDialogView(
        selectedCurrency: currencyModel,
        onSelect: (p0) {
          currencyModel = p0;
          setState(() {});
          context.pop();
        },
      )
    );
  }

  void showThemeDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: CustomText(
            title: _localizations!.appearance,
            textStyle: getSemiBoldStyle(
              color: Helper.isDark 
              ? AppColors.white.withValues(alpha: 0.9) 
              : AppColors.black,
            ),
          ),
          backgroundColor: Helper.isDark 
          ? AppColors.dialogColorDark 
          : AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s10)),
          insetPadding: const EdgeInsets.all(AppSize.s12),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSize.s16, 
            vertical: AppSize.s16
          ),
          content: SizedBox(
            width: kIsWeb ? MyAppTheme.columnWidth : (MyAppTheme.columnWidth - AppSize.s60),
            child: Column(
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
                      AnalyticsService.instance.logEvent(
                        name: AnalyticsEvents.settingsChanged,
                        parameters: {'setting_name': 'theme'},
                      );
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
                            Preferences.getString(key: AppStrings.prefTheme) == data.theme 
                            ? AppIcons.radioCheckIcon 
                            : AppIcons.uncheckIcon,
                            color: Preferences.getString(key: AppStrings.prefTheme) == data.theme 
                            ? AppColors.primaryColor
                            : AppColors.grey
                          ),
                          const SizedBox(width: AppSize.s10),
                          CustomText(
                            title: data.title,
                            textStyle: getRegularStyle(
                              color: Helper.isDark 
                              ? AppColors.white.withValues(alpha: 0.9) 
                              : AppColors.black,
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
          ),
        );
      }
    );
  }

  void showDashboardTransactionModeDialog({required BuildContext context}) {
    showGeneralDialog(
      context: context, 
      barrierDismissible: true,
      barrierLabel: AppStrings.close,
      pageBuilder: (_, a1, _) => ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(a1),
        child: TransactionModeDialog(
          dashboardTransactionModeList: dashboardTransactionModeList,
          onChange: (mode) {
            _settingBloc.add(SettingsOnDashboardTransactionModeEvent(mode: mode));
            context.pop();
          },
        )
      ),
    );
  }

  void showLanguageDialog({required BuildContext context}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: AppStrings.close,
      pageBuilder: (_, a1, _) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(a1),
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s10)),
            backgroundColor: Helper.isDark ? AppColors.topDarkColor : AppColors.white,
            insetPadding: const EdgeInsets.all(AppSize.s12),
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSize.s18, vertical: AppSize.s16),
            content: Container(
              width: kIsWeb ? MyAppTheme.columnWidth : (MyAppTheme.columnWidth - AppSize.s60),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSize.s10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: _localizations!.language,
                        textStyle: getSemiBoldStyle(),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.s10),
                  ...List.generate(
                    languageList.length,
                    (index) {
                      var data = languageList[index];
                      return InkWell(
                        onTap: () { 
                          context.read<MyAppBloc>().add(MyAppChangeLanguageEvent(locale: data.locale));
                          context.pop();
                          AnalyticsService.instance.logEvent(
                            name: AnalyticsEvents.settingsChanged,
                            parameters: {'setting_name': 'language'},
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.s4,
                            vertical: AppSize.s8
                          ),
                          margin: EdgeInsets.only(bottom: AppSize.s4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Preferences.getString(key: AppStrings.prefLanguage) == data.selectedLanguage 
                                ? AppIcons.radioCheckIcon 
                                : AppIcons.uncheckIcon,
                                color: Preferences.getString(key: AppStrings.prefLanguage) == data.selectedLanguage 
                                ? AppColors.primaryColor
                                : AppColors.grey
                              ),
                              const SizedBox(width: AppSize.s10),
                              CustomText(
                                title: data.title,
                                textStyle: getRegularStyle(
                                  color: Helper.isDark 
                                  ? AppColors.white.withValues(alpha: 0.9) 
                                  : AppColors.black,
                                  fontSize: AppSize.s14
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                ]
              ),
            ),
          )
        );
      }
    );
  }

}
