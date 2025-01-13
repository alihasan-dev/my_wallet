import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../constants/app_theme.dart';
import '../../../utils/preferences.dart';
import '../../../widgets/custom_image_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_extension_method.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_style.dart';
import '../../../constants/app_size.dart';
import '../../../widgets/custom_text.dart';
import '../../../features/dashboard/application/bloc/dashboard_bloc.dart';
import '../../../features/dashboard/domain/user_model.dart';
import '../../../widgets/custom_empty_widget.dart';
import '../../../utils/helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'add_user_dialog.dart';
part 'dashboard_web_view.dart';

class DashboardScreen extends StatefulWidget {
  final String? userId;
  const DashboardScreen({super.key, this.userId});
  @override
  State createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen>  with Helper, WidgetsBindingObserver {

  List<UserModel> allUsers = [];
  bool isLoading = true;
  bool showUnverified = true;
  late TextEditingController searchTextController;
  AppLocalizations? _localizations;
  late DashboardBloc _dashboardBloc;
  bool searchFieldEnable = false;
  bool isBioAuthenticated = false;
  bool enableBiometricOnChangeLifeCycle = false;
  bool isBiometricDialogOpen = false;
  late LocalAuthentication _localAuthentication;
  String? selectedUserId;
  int selectedUserCount = 0;

  var maskFormatter = MaskTextInputFormatter(
    mask: '####-###-###',
    filter: {"#": RegExp(r'[0-9]')}
  );
  late DateFormat dateFormat;

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addObserver(this);
    _dashboardBloc = context.read<DashboardBloc>();
    _localizations = AppLocalizations.of(context)!;
    _localAuthentication = LocalAuthentication();
    if(Preferences.getBool(key: AppStrings.prefBiometricAuthentication) && !kIsWeb && !isBiometricDialogOpen) {
      openBiometricDialog();
      Preferences.setBool(key: AppStrings.prefBiometricAuthentication, value: false);
    } else {
      isBioAuthenticated = true;
    }
    searchTextController = TextEditingController();
    dateFormat = DateFormat.yMMMd();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    selectedUserId = widget.userId;
    return Scaffold(body: mainContent(context: context));
  }

  Widget mainContent({required BuildContext context}) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        switch (state) {
          case DashboardFailedState _:
            hideLoadingDialog(context: context);
            showSnackBar(context: context, title: state.title, message: state.message);
            break;
          case DashboardAllUserState _:
            isLoading = false;
            allUsers.clear();
            allUsers.addAll(state.allUser);
            if(state.isCancelSearch) {
              searchFieldEnable = false;
              searchTextController.clear();
            }
            selectedUserCount = allUsers.where((item) => item.isSelected).length;
            break;
          case DashboardSuccessState _:
            hideLoadingDialog(context: context);
            break;
          case DashboardSelectedUserState _:
            selectedUserId = state.userId;
            break;
          case DashboardSearchFieldEnableState _:
            searchFieldEnable = !searchFieldEnable;
            break;
          case DashboardLoadingState _:
            isLoading = true;
            break;
          case DashboardBiometricAuthState _:
            isBioAuthenticated = state.isAuthenticated;
            break;
          default:
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            DashboardWebView(
              dashboardBloc: _dashboardBloc,
              dashboardScreenState: this
            ),
            Visibility(
              visible: !isBioAuthenticated && !kIsWeb,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                height: isBioAuthenticated ? 0 : double.maxFinite,
                width: isBioAuthenticated ? 0 : double.maxFinite,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: AppColors.black.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  void addUserDialog() {
    showDialog(
      context: context, 
      builder: (_) => const AddUserDialog()
    );
  }

  Future<void> onClickLogout({required BuildContext context}) async {
    if(await confirmationDialog(context: context, title: _localizations!.logout, content: _localizations!.logoutMsg, localizations: _localizations!)) {
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
    if(!await biometricAuthentication()) {
      showDialog(
        context: context,
        barrierDismissible: false, 
        builder: (_){
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: CustomText(
                title: _localizations!.biometricAuthFailed, 
                textStyle: getBoldStyle(
                  color: Helper.isDark 
                  ? AppColors.white.withValues(alpha: 0.9) 
                  : AppColors.black
                ),
              ),
              content: CustomText(
                title: _localizations!.biometricAuthFailedMessage, 
                textColor: Helper.isDark 
                ? AppColors.white.withValues(alpha: 0.9) 
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
    if(await _localAuthentication.isDeviceSupported()) {
      try {
        isBiometricDialogOpen = true;
        data =  await _localAuthentication.authenticate(
          localizedReason: AppStrings.biometricMessage,
          options: const AuthenticationOptions(biometricOnly: false, stickyAuth: true)
        );
        isBiometricDialogOpen = !data;
      } catch (e) {
        showDialog(
          context: context,
          barrierDismissible: false, 
          builder: (_) {
            return PopScope(
              canPop: false,
              child: AlertDialog(
                title: CustomText(
                  title: _localizations!.biometricAuthFailed,
                  textStyle: getBoldStyle(
                    color: Helper.isDark 
                    ? AppColors.white.withValues(alpha: 0.9) 
                    : AppColors.black
                  ),
                ),
                content: CustomText(
                  title: _localizations!.bioAuthFailedTooManyAttemptMessage, 
                  textColor: Helper.isDark 
                  ? AppColors.white.withValues(alpha: 0.9) 
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
    _dashboardBloc.add(DashboardBiometricAuthEvent(isAuthenticated: data));
    return data;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final location = GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;
    if(location != AppRoutes.dashboard) return;
    switch (state) {
      case AppLifecycleState.resumed:
        if(enableBiometricOnChangeLifeCycle && !isBioAuthenticated && !kIsWeb && !isBiometricDialogOpen && Preferences.getBool(key: AppStrings.prefEnableBiometric)) {
          openBiometricDialog();
        }
        break;
      case AppLifecycleState.inactive:
        if(isBioAuthenticated && !kIsWeb && Preferences.getBool(key: AppStrings.prefEnableBiometric)) {
          enableBiometricOnChangeLifeCycle = true;
          _dashboardBloc.add(DashboardBiometricAuthEvent(isAuthenticated: false));
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }
  
}