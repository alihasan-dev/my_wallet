import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_wallet/constants/app_icons.dart';
import '../../../features/dashboard/application/dashboard_screen.dart';
import '../../../features/home/application/bloc/home_bloc.dart';
import '../../../features/home/application/bloc/home_event.dart';
import '../../../features/home/application/bloc/home_state.dart';
import '../../../features/home/domain/drawer_widget_title_model.dart';
import '../../../features/profile/application/profile_screen.dart';
import '../../../routes/app_routes.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_style.dart';
import '../../../utils/helper.dart';
import '../../../utils/preferences.dart';
import '../../../widgets/custom_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with Helper {

  int pageIndex = 0;
  AppLocalizations? _localizations;
  late LocalAuthentication _localAuthentication;
  final _widgetTitleList = <WidgetTitleModel>[];

  @override
  void initState() {
    _localAuthentication = LocalAuthentication();
    // if(Preferences.getBool(key: AppStrings.prefBiometricAuthentication)) {
    //   openBiometricDialog();
    //   Preferences.setBool(key: AppStrings.prefBiometricAuthentication, value: false);
    // }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context)!;
    _widgetTitleList.clear();
    _widgetTitleList.add(WidgetTitleModel(screenWidget: const DashboardScreen(), title: _localizations!.dashboard));
    _widgetTitleList.add(WidgetTitleModel(screenWidget: const ProfileScreen(), title: _localizations!.profile));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(),
      child: Builder(
        builder: (context) {
          return WillPopScope(
            onWillPop: () => onPressBack(context, _localizations!),
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state){
                switch (state) {
                  case HomeDrawerItemState _:
                    pageIndex = state.index;
                    break;
                  default:
                }
                return Scaffold(
                  appBar: AppBar(
                    centerTitle: true, 
                    backgroundColor: AppColors.primaryColor,
                    title: CustomText(
                      title: _widgetTitleList[pageIndex].title, 
                      textStyle: getBoldStyle(color: AppColors.white)
                    ),
                    iconTheme: const IconThemeData(color: AppColors.white),
                    actions: [
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        position: PopupMenuPosition.under,
                        itemBuilder: (_) {
                          return <PopupMenuEntry<String>> [
                            const PopupMenuItem<String>(
                              value: AppStrings.settings,
                              child: ListTile(
                                leading: Icon(Icons.settings),
                                title: Text(AppStrings.settings),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: AppStrings.logout,
                              child: ListTile(
                                leading: Icon(Icons.login_outlined),
                                title: Text(AppStrings.logout),
                              ),
                            ),
                          ];
                        },
                        onSelected: (value) {
                          log(value);
                          switch (value) {
                            case AppStrings.settings:
                              context.push(AppRoutes.appearanceScreen);
                              break;
                            case AppStrings.logout:
                              onClickLogout(context: context, localizations: _localizations!);
                              break;
                          }
                        },
                      )
                    ]
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: pageIndex,
                    selectedItemColor: AppColors.primaryColor,
                    onTap: (index) => context.read<HomeBloc>().add(HomeDrawerItemEvent(index: index)),
                    items: [
                      BottomNavigationBarItem(
                        label: _localizations!.dashboard,
                        icon: const Icon(AppIcons.homeIcon)
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(AppIcons.personIcon),
                        label: _localizations!.profile
                      ),
                    ],
                  ),
                  body: _widgetTitleList[pageIndex].screenWidget
                );
              }
            ),
          );
        }
      ),
    );
  }

  Future<bool> onPressBack(BuildContext context, AppLocalizations localizations) async {
    if(pageIndex == 0) {
      return await confirmationDialog(
        context: context, 
        title: localizations.exit, 
        content: localizations.exitMsg,
        localizations: localizations
      );
    } else {
      context.read<HomeBloc>().add(HomeBackPressEvent(pageIndex: 0));
      return false;
    }
  }

  Future<void> onClickLogout({required BuildContext context, required AppLocalizations localizations}) async {
    if(await confirmationDialog(context: context, title: localizations.logout, content: localizations.logoutMsg, localizations: localizations)) {
      Preferences.setBool(key: AppStrings.prefBiometricAuthentication, value: false);
      await Preferences.clearPreferences(key: AppStrings.prefUserId);
      await Preferences.clearPreferences(key: AppStrings.prefBiometric);
      if(context.mounted){
        while (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
        }
        GoRouter.of(context).pushReplacement(AppRoutes.loginScreen);
      }
    }
  }

  ///method used to open the biometric failed info dialog
  Future<void> openBiometricDialog() async {
    if(!await biometricAuthentication() && context.mounted){
      showDialog(
        context: context,
        barrierDismissible: false, 
        builder: (_){
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              title: CustomText(
                title: _localizations!.biometricAuthFailed, 
                textStyle: getBoldStyle(
                  color: Helper.isDark 
                  ? AppColors.white.withOpacity(0.9) 
                  : AppColors.black
                ),
              ),
              content: CustomText(
                title: _localizations!.biometricAuthFailedMessage, 
                textColor: Helper.isDark 
                ? AppColors.white.withOpacity(0.9) 
                : AppColors.black
              ),
              actions: [
                TextButton(
                  onPressed: () => exit(0),
                  child: CustomText(
                    title: _localizations!.cancel,
                    textStyle: getBoldStyle(color: AppColors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.pop();
                    Future.delayed(Duration.zero, () => openBiometricDialog());
                  },
                  child: CustomText(
                    title: _localizations!.reAuthenticate,
                    textStyle: getBoldStyle(color: AppColors.primaryColor),
                  ),
                ),
              ],
            ),
          );
        }
      );
    }
  }

  ///method used to handle the biometric and FaceID authentication
  Future<bool> biometricAuthentication() async {
    var data = true;
    if(await _localAuthentication.isDeviceSupported()){
      try {
        data =  await _localAuthentication.authenticate(
          localizedReason: AppStrings.biometricMessage,
          options: const AuthenticationOptions(biometricOnly: true)
        );
      } catch (e) {
        if(context.mounted){
          showDialog(
            context: context,
            barrierDismissible: false, 
            builder: (_) {
              return WillPopScope(
                onWillPop: () => Future.value(false),
                child: AlertDialog(
                  title: CustomText(
                    //title: "",
                    title: _localizations!.biometricAuthFailed,
                    textStyle: getBoldStyle(
                      color: Helper.isDark 
                      ? AppColors.white.withOpacity(0.9) 
                      : AppColors.black
                    ),
                  ),
                  content: CustomText(
                    title: _localizations!.bioAuthFailedTooManyAttemptMessage, 
                    textColor: Helper.isDark 
                    ? AppColors.white.withOpacity(0.9) 
                    : AppColors.black
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => exit(0),
                      child: CustomText(
                        title: _localizations!.cancel,
                        textStyle: getBoldStyle(color: AppColors.red),
                      ),
                    ),
                  ],
                ),
              );
            }
          );
        }
      }
    }
    return data;
  }

}