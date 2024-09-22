import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../features/signup/application/bloc/signup_bloc.dart';
import '../../../features/signup/application/bloc/signup_event.dart';
import '../../../features/signup/application/bloc/signup_state.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/helper.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_style.dart';
import '../../../constants/app_size.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_inkwell_widget.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with Helper {
  
  var nameTextController = TextEditingController();
  var emailTextController = TextEditingController();
  var passwordTextController = TextEditingController();
  AppLocalizations? _localizations;
  var errorName = AppStrings.emptyString;
  var errorEmail = AppStrings.emptyString;
  var errorPassword = AppStrings.emptyString;
  bool showPassword = true;

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_) => SignupBloc(),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0, backgroundColor: AppColors.primaryColor),
        // backgroundColor: Helper.isDark ? AppColors.backgroundColorDark : AppColors.white,
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
                context.go(AppRoutes.homeScreen);
                break;
              default:
            }
          },
          builder: (context, state) {
            switch (state) {
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
            return ListView(
              padding: const EdgeInsets.all(AppSize.s28),
              children: [
                Center(child: Image.asset(AppImages.appImage, height: 90, width: 90)),
                const SizedBox(height: AppSize.s10),
                CustomTextField(
                  title: _localizations!.name,
                  isPasswordField: false,
                  isMandatory: true,
                  textEditingController: nameTextController,
                  errorText: errorName,
                  onChange: (value) => context.read<SignupBloc>().add(SignupNameChangeEvent(name: value)),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSize.s10),
                CustomTextField(
                  title: _localizations!.email,
                  isPasswordField: false,
                  isMandatory: true,
                  textEditingController: emailTextController,
                  errorText: errorEmail,
                  onChange: (value) => context.read<SignupBloc>().add(SignupEmailChangeEvent(email: value)),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSize.s10),
                CustomTextField(
                  title: _localizations!.password,
                  isPasswordField: showPassword,
                  isMandatory: true,
                  textEditingController: passwordTextController,
                  onShowPassword: () => context.read<SignupBloc>().add(SignupShowPasswordEvent(isVisible: showPassword)),
                  errorText: errorPassword,
                  onChange: (value) => context.read<SignupBloc>().add(SignupPasswordChangeEvent(password: value)),
                  onSubmitted: (_) => context.read<SignupBloc>().add(SignupSubmitEvent(name: nameTextController.text, email: emailTextController.text, password: passwordTextController.text)),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: AppSize.s24),
                CustomButton(
                  title: _localizations!.signup,
                  titleSize: AppSize.s16, 
                  onTap: () => context.read<SignupBloc>().add(SignupSubmitEvent(name: nameTextController.text, email: emailTextController.text, password: passwordTextController.text))
                ),
                const SizedBox(height: AppSize.s20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      title: '${_localizations!.alreadyHaveAnAccount}  ', 
                      textStyle: getMediumStyle(color: Helper.isDark ? AppColors.white.withOpacity(0.8) : AppColors.black)
                    ),
                    CustomInkWellWidget(
                      onTap: () => context.pop(), 
                      widget: CustomText(
                        title: _localizations!.login, 
                        textStyle: getSemiBoldStyle(fontSize: AppSize.s14, color: AppColors.primaryColor)
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        ),
      ),
    );
  }
  
}