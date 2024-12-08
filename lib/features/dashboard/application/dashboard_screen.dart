import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
part 'dashboard_mobile_view.dart';
part 'dashboard_web_view.dart';

class DashboardScreen extends StatefulWidget{
  final String? userId;
  const DashboardScreen({super.key, this.userId});
  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen>  with Helper {

  List<UserModel> allUsers = [];
  bool isLoading = true;
  bool showUnverified = true;
  late TextEditingController searchTextController;
  AppLocalizations? _localizations;
  String? selectedUserId;

  var maskFormatter = MaskTextInputFormatter(
    mask: '####-###-###',
    filter: {"#": RegExp(r'[0-9]')}
  );
  late DateFormat dateFormat;

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context)!;
    searchTextController = TextEditingController();
    dateFormat = DateFormat.yMMMd();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    selectedUserId = widget.userId;
    return kIsWeb
    ? Scaffold(body: mainContent(context: context))
    : mainContent(context: context);
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
              searchTextController.clear();
            }
            break;
          case DashboardSuccessState _:
            hideLoadingDialog(context: context);
            break;
          case DashboardSelectedUserState _:
            selectedUserId = state.userId;
            break;
          default:
        }
      },
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            switch (context.screenWidth.screenDimension) {
              // case ScreenType.mobile:
              case ScreenType.tablet:
                return DashboardMobileView(
                  dashboardBloc: context.read<DashboardBloc>(), 
                  dashboardScreenState: this
                );
              default:
              return DashboardWebView(
                dashboardBloc: context.read<DashboardBloc>(), 
                dashboardScreenState: this
              );
            }
          },
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
  
}