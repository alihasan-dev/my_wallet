import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
import '../../../widgets/custom_image_widget.dart' show CustomImageWidget;
import '../../../widgets/custom_inkwell_widget.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_field.dart';
part 'signup_web_view.dart';
part 'signup_mobile_view.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_) => SignupBloc(),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0, backgroundColor: AppColors.primaryColor),
        body: BlocConsumer<SignupBloc, SignupState>(
          listener: (context, state) {
            switch (state) {
              case SignupFailedState _:
                hideLoadingDialog(context: context);
                showSnackBar(context: context, title: state.title, message: state.message);
                break;
              case SignupLoadingState _:
                showLoadingDialog(context: context);
                break;
              case SignupSuccessState _:
                hideLoadingDialog(context: context);
                Preferences.setBool(key: AppStrings.prefBiometricAuthentication, value: false);
                context.go(AppRoutes.dashboard);
                break;
              case SignupEmailFieldState _:
                errorEmail = state.emailMessage;
                break;
              case SignupPasswordFieldState _:
                errorPassword = state.passwordMessage;
                break;
              case SignupPasswordVisibilityState _:
                showPassword = state.isVisible;
                break;
              case SignupNameFieldState _:
                errorName = state.nameMessage;
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
      ),
    );
  }
  
}