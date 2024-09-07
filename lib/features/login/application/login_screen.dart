import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_style.dart';
import '../../../constants/app_size.dart';
import '../../../widgets/custom_checkbox_widget.dart';
import '../../../widgets/custom_inkwell_widget.dart';
import '../../../features/login/application/bloc/login_bloc.dart';
import '../../../features/login/application/bloc/login_event.dart';
import '../../../features/login/application/bloc/login_state.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/helper.dart';
import '../../../utils/preferences.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>  with Helper{

  late TextEditingController emailTextController;
  late TextEditingController passwordTextController;
  AppLocalizations? _localizations;
  var errorEmail = AppStrings.emptyString;
  var errorPassword = AppStrings.emptyString;
  bool showPassword = true;
  bool isRememberMe = false;

  @override
  void initState() {
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    if(Preferences.getBool(key: AppStrings.prefRememberMe)){
      emailTextController.text = Preferences.getString(key: AppStrings.prefEmail);
      passwordTextController.text = Preferences.getString(key: AppStrings.prefPassword);
      isRememberMe = true;
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, backgroundColor: AppColors.primaryColor),
      backgroundColor: Helper.isDark ? AppColors.backgroundColorDark : AppColors.white,
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          switch (state.runtimeType) {
            case LoginFailedState:
              hideLoadingDialog(context: context);
              state = state as LoginFailedState;
              showSnackBar(context: context, title: state.title, message: state.message);
              break;
            case LoginLoadingState:
              showLoadingDialog(context: context);
              break;
            case LoginSuccessState:
              hideLoadingDialog(context: context);
              context.go(AppRoutes.homeScreen);
              break;
            default:
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case LoginEmailFieldState:
              state = state as LoginEmailFieldState;
              errorEmail = state.emailMessage;
              break;
            case LoginPasswordFieldState:
              state = state as LoginPasswordFieldState;
              errorPassword = state.passwordMessage;
              break;
            case LoginPasswordVisibilityState:
              state = state as LoginPasswordVisibilityState;
              showPassword = state.isVisible;
              break;
            case LoginRememberMeState:
              state = state as LoginRememberMeState;
              isRememberMe = state.isRemmeberMe;
              break;
            default:
          }
          return ListView(
            padding: const EdgeInsets.all(AppSize.s28),
            children: [
              const SizedBox(height: AppSize.s10),
              Center(child: Image.asset(AppImages.appImage, height: 80, width: 80)),
              const SizedBox(height: AppSize.s20),
              CustomTextField(
                // title: AppStrings.email,
                title: _localizations!.email,
                isPasswordField: false,
                isMandatory: true,
                textEditingController: emailTextController,
                errorText: errorEmail,
                onChange: (value) => context.read<LoginBloc>().add(LoginEmailChangeEvent(email: value)),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSize.s10),
              CustomTextField(
                title: _localizations!.password,
                isPasswordField: showPassword,
                isMandatory: true,
                textEditingController: passwordTextController,
                onShowPassword: () => context.read<LoginBloc>().add(LoginShowPasswordEvent(isVisible: showPassword)),
                errorText: errorPassword,
                onChange: (value) => context.read<LoginBloc>().add(LoginPasswordChangeEvent(password: value)),
                onSubmitted: (_) => context.read<LoginBloc>().add(LoginSubmitEvent(email: emailTextController.text, password: passwordTextController.text, isRememberMe: isRememberMe)),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: AppSize.s12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomCheckBoxWidget(
                        value: isRememberMe, 
                        onChange: (value) => context.read<LoginBloc>().add(LoginRememberMeEvent(value: value!))
                      ),
                      const SizedBox(width: AppSize.s10),
                      CustomText(title: _localizations!.rememberMe, textStyle: getMediumStyle(color: Helper.isDark ? AppColors.white.withOpacity(0.8) : AppColors.black))
                    ],
                  ),
                  // InkWell(
                  //   onTap: () => context.push(AppRoutes.forgotPasswordScreen),
                  //   child: CustomText(
                  //     title: AppStrings.forgotPassword, 
                  //     textStyle: getMediumStyle(color: AppColors.black)
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: AppSize.s26),
              CustomButton(
                title: _localizations!.login,
                titleSize: AppSize.s16, 
                onTap: () => context.read<LoginBloc>().add(LoginSubmitEvent(email: emailTextController.text, password: passwordTextController.text, isRememberMe: isRememberMe))
              ),
              const SizedBox(height: AppSize.s20),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    title: '${_localizations!.dontHaveAccount}  ', 
                    textStyle: getMediumStyle(color: Helper.isDark ? AppColors.white.withOpacity(0.8) : AppColors.black)
                  ),
                  CustomInkWellWidget(
                    onTap: () => context.push(AppRoutes.signupScreen), 
                    widget: CustomText(
                      title: _localizations!.signup, 
                      textStyle: getSemiBoldStyle(fontSize: AppSize.s14, color: AppColors.primaryColor)
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      ),
    );
  }
}