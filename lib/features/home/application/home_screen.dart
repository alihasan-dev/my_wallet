import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'left_navigation_drawer_screen.dart';
import '../../../features/dashboard/application/dashboard_screen.dart';
import '../../../features/home/application/bloc/home_bloc.dart';
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
  late LocalAuthentication _localAuthentication;
  final _widgetTitleList = <WidgetTitleModel>[
    WidgetTitleModel(screenWidget: const DashboardScreen(), title: AppStrings.dashboard),
    WidgetTitleModel(screenWidget: const ProfileScreen(), title: AppStrings.profile)
  ];

  @override
  void initState() {
    _localAuthentication = LocalAuthentication();
    if(Preferences.getBool(key: AppStrings.prefBiometricAuthentication)){
      openBiometricDialog();
      Preferences.setBool(key: AppStrings.prefBiometricAuthentication, value: false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(),
      child: Builder(
        builder: (context){
          return WillPopScope(
            onWillPop: () => onPressBack(context),
            child: BlocConsumer<HomeBloc, HomeState>(
              builder: (context, state){
                switch (state.runtimeType) {
                  case HomeDrawerItemState:
                    state = state as HomeDrawerItemState;
                    pageIndex = state.index;
                    break;
                  default:
                }
                return Scaffold(
                  appBar: AppBar(
                    centerTitle: true, 
                    title: CustomText(
                      title: _widgetTitleList[pageIndex].title, 
                      textStyle: getBoldStyle(color: AppColors.white)
                    ),
                    iconTheme: const IconThemeData(color: AppColors.white),
                  ),
                  drawer: LeftNavigationDrawerScreen(
                    onPressed: (value){
                      switch (value) {
                        case -1:
                          context.pop();
                          onClickLogout(context: context);
                          break;
                        default:
                          context.pop();
                          context.read<HomeBloc>().add(HomeDrawerItemEvent(index: value));
                      }
                    },
                    selectedIndex: pageIndex,
                  ),
                  body: _widgetTitleList[pageIndex].screenWidget
                );
              },  
              listener: (context, state){}
            ),
          );
        }
      ),
    );
  }

  Future<bool> onPressBack(BuildContext context) async {
    if(pageIndex == 0){
      return await confirmationDialog(
        context: context, 
        title: AppStrings.exit, 
        content: AppStrings.exitMessage
      );
    } else {
      context.read<HomeBloc>().add(HomeBackPressEvent(pageIndex: 0));
      return false;
    }
  }

  Future<void> onClickLogout({required BuildContext context}) async {
    if(await confirmationDialog(context: context, title: AppStrings.logout, content: AppStrings.logoutMessage)) {
      Preferences.setBool(key: AppStrings.prefBiometricAuthentication, value: false);
      await Preferences.clearPreferences(key: AppStrings.prefUserId);
      await Preferences.clearPreferences(key: AppStrings.prefBiometric);
      if(context.mounted) {
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
                title: AppStrings.biometricAuthFailed, 
                textStyle: getBoldStyle(color: AppColors.black),
              ),
              content: const CustomText(
                title: AppStrings.biometricAuthFailedMessage, 
                textColor: AppColors.black
              ),
              actions: [
                TextButton(
                  onPressed: () => exit(0),
                  child: CustomText(
                    title: AppStrings.cancel,
                    textStyle: getBoldStyle(color: AppColors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.pop();
                    Future.delayed(Duration.zero, () => openBiometricDialog());
                  },
                  child: CustomText(
                    title: AppStrings.reAuthenticate,
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
        if(context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false, 
            builder: (_) {
              return WillPopScope(
                onWillPop: () => Future.value(false),
                child: AlertDialog(
                  title: CustomText(
                    title: AppStrings.biometricAuthFailed,
                    textStyle: getBoldStyle(color: AppColors.black),
                  ),
                  content: const CustomText(
                    title: AppStrings.bioAuthFailedTooManyAttemptMessage, 
                    textColor: AppColors.black
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => exit(0),
                      child: CustomText(
                        title: AppStrings.close,
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