import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../utils/app_extension_method.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_style.dart';
import '../../../constants/app_size.dart';
import '../../../constants/app_theme.dart';
import '../../../widgets/custom_checkbox_widget.dart';
import '../../../widgets/custom_inkwell_widget.dart';
import '../../../features/login/application/bloc/login_bloc.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/helper.dart';
import '../../../utils/preferences.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_field.dart';
import 'package:my_wallet/widgets/mobile_google_sign_in_button.dart'
  if(dart.library.html) 'package:my_wallet/widgets/web_google_sign_in_button.dart';
part 'login_mobile_view.dart';
part 'login_web_view.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>  with Helper {

  late TextEditingController emailTextController;
  late TextEditingController passwordTextController;
  late LoginBloc _loginBloc;
  var errorEmail = AppStrings.emptyString;
  var errorPassword = AppStrings.emptyString;
  bool showPassword = true;
  bool isRememberMe = false;
  GoogleSignIn? gsi;

  @override
  void initState() {
    _loginBloc = context.read<LoginBloc>();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    if(Preferences.getBool(key: AppStrings.prefRememberMe)) {
      emailTextController.text = Preferences.getString(key: AppStrings.prefEmail);
      passwordTextController.text = Preferences.getString(key: AppStrings.prefPassword);
      isRememberMe = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, backgroundColor: AppColors.primaryColor),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          switch (state) {
            case LoginFailedState _:
              hideLoadingDialog(context: context);
              if(state.canShowSnackBar) {
                showSnackBar(context: context, title: state.title, message: state.message);
              }
              break;
            case LoginLoadingState _:
              showLoadingDialog(context: context);
              break;
            case LoginSuccessState _:
              hideLoadingDialog(context: context);
              showSnackBar(context: context, title: state.title, message: state.message, color: AppColors.green);
              Preferences.setBool(key: AppStrings.prefBiometricAuthentication, value: false);
              context.go(AppRoutes.dashboard);
              break;
            case LoginEmailFieldState _:
              errorEmail = state.message;
              break;
            case LoginPasswordFieldState _:
              errorPassword = state.message;
              break;
            case LoginPasswordVisibilityState _:
              showPassword = state.isVisible;
              break;
            case LoginRememberMeState _:
              isRememberMe = state.isRemmeberMe;
              break;
            default:
          }
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              switch (constraints.maxWidth.screenDimension) {
                case ScreenType.mobile:
                  return LoginMobileView(
                    loginBloc: _loginBloc,
                    loginScreenState: this
                  );
                default:
                  return LoginWebView(
                    loginBloc: _loginBloc, 
                    loginScreenState: this
                  );
              }
            }
          );
        }
      ),
    );
  }
}