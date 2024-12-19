part of 'login_screen.dart';

class LoginMobileView extends StatelessWidget {

  final LoginScreenState loginScreenState;
  final LoginBloc loginBloc;
  
  const LoginMobileView({
    super.key, 
    required this.loginScreenState, 
    required this.loginBloc
  });

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(AppSize.s28),
      children: [
        Center(child: Image.asset(AppImages.appImage, height: 90, width: 90)),
        const SizedBox(height: AppSize.s10),
        CustomTextField(
          title: localizations.email,
          isPasswordField: false,
          isMandatory: true,
          textEditingController: loginScreenState.emailTextController,
          errorText: loginScreenState.errorEmail,
          onChange: (value) => loginBloc.add(LoginEmailChangeEvent(email: value)),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSize.s10),
        CustomTextField(
          title: localizations.password,
          isPasswordField: loginScreenState.showPassword,
          isMandatory: true,
          textEditingController: loginScreenState.passwordTextController,
          onShowPassword: () => loginBloc.add(LoginShowPasswordEvent(isVisible: loginScreenState.showPassword)),
          errorText: loginScreenState.errorPassword,
          onChange: (value) => loginBloc.add(LoginPasswordChangeEvent(password: value)),
          onSubmitted: (_) => loginBloc.add(LoginSubmitEvent(email: loginScreenState.emailTextController.text, password: loginScreenState.passwordTextController.text, isRememberMe: loginScreenState.isRememberMe)),
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: AppSize.s10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomCheckBoxWidget(
                  value: loginScreenState.isRememberMe, 
                  onChange: (value) => loginBloc.add(LoginRememberMeEvent(value: value!))
                ),
                const SizedBox(width: AppSize.s10),
                CustomText(
                  title: localizations.rememberMe, 
                  textStyle: getMediumStyle(
                    color: Helper.isDark 
                    ? AppColors.white.withValues(alpha: 0.8) 
                    : AppColors.black
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () => context.go('/login/forgotPassword'),
              child: CustomText(
                title: localizations.forgotPassword, 
                textStyle: getMediumStyle(
                  color: Helper.isDark 
                  ? AppColors.white.withValues(alpha: 0.8) 
                  : AppColors.black
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSize.s26),
        CustomButton(
          title: localizations.login,
          titleSize: AppSize.s16, 
          onTap: () => loginBloc.add(LoginSubmitEvent(
            email: loginScreenState.emailTextController.text, 
            password: loginScreenState.passwordTextController.text, 
            isRememberMe: loginScreenState.isRememberMe
          ))
        ),
        const SizedBox(height: AppSize.s20),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              title: '${localizations.dontHaveAccount}  ', 
              textStyle: getMediumStyle(
                color: Helper.isDark 
                ? AppColors.white.withValues(alpha: 0.8) 
                : AppColors.black
              ),
            ),
            CustomInkWellWidget(
              onTap: () => context.push(AppRoutes.signupScreen), 
              widget: CustomText(
                title: localizations.signup, 
                textStyle: getSemiBoldStyle(fontSize: AppSize.s14, color: AppColors.primaryColor)
              ),
            ),
          ],
        ),
      ],
    );
  }
}