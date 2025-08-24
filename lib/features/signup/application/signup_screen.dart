import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../../constants/app_icons.dart';
import '../../../utils/app_extension_method.dart';
import '../../../constants/app_theme.dart';
import '../../../features/signup/application/bloc/signup_bloc.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/helper.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_style.dart';
import '../../../constants/app_size.dart';
import '../../../utils/preferences.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_inkwell_widget.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_field.dart';
import 'package:my_wallet/widgets/mobile_google_sign_in_button.dart'
  if(dart.library.html) 'package:my_wallet/widgets/web_google_sign_in_button.dart';
part 'signup_web_view.dart';
part 'signup_mobile_view.dart';
part 'signup_alert.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> with Helper {
  
  var nameTextController = TextEditingController();
  var emailTextController = TextEditingController();
  var passwordTextController = TextEditingController();
  var errorName = AppStrings.emptyString;
  var errorEmail = AppStrings.emptyString;
  var errorPassword = AppStrings.emptyString;
  bool showPassword = true;
  late SignupBloc _signupBloc;

  @override
  void initState() {
    _signupBloc = context.read<SignupBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showSignupWarningDialog());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, backgroundColor: AppColors.primaryColor),
      body: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          switch (state) {
            case SignupFailedState _:
              hideLoadingDialog(context: context);
              if(state.canShowSnaclBar) {
                showSnackBar(context: context, title: state.title, message: state.message);
              }
              break;
            case SignupLoadingState _:
              showLoadingDialog(context: context);
              break;
            case SignupSuccessState _:
              hideLoadingDialog(context: context);
              Preferences.setBool(key: AppStrings.prefBiometricAuthentication, value: false);
              showSnackBar(context: context, title: state.title, message: state.message, color: AppColors.green);
              context.go(AppRoutes.dashboard);
              break;
            case SignupEmailFieldState _:
              errorEmail = state.message;
              break;
            case SignupPasswordFieldState _:
              errorPassword = state.message;
              break;
            case SignupPasswordVisibilityState _:
              showPassword = state.isVisible;
              break;
            case SignupNameFieldState _:
              errorName = state.message;
              break;
            default:
          }
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              switch (constraints.maxWidth.screenDimension) {
                case ScreenType.mobile:
                  return SignupMobileView(
                    signupBloc: _signupBloc,
                    signupScreenState: this
                  );
                default:
                  return SignupWebView(
                    signupBloc: _signupBloc, 
                    signupScreenState: this
                  );
              }
            }
          );
        }
      ),
    );
  }

  void _showSignupWarningDialog() {
    showGeneralDialog(
      context: context, 
      barrierDismissible: true,
      barrierLabel: AppStrings.close,
      pageBuilder: (context, a1, a2) => ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(a1),
        child: const SignupAlert()
      )
    );
  }
  
}