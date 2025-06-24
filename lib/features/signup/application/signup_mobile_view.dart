part of 'signup_screen.dart';

class SignupMobileView extends StatelessWidget {

  final SignupBloc signupBloc;
  final SignupScreenState signupScreenState;

  const SignupMobileView({
    super.key,
    required this.signupBloc,
    required this.signupScreenState
  });

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(AppSize.s28),
      children: [
        Center(child: Image.asset(AppImages.appImage, height: 90, width: 90)),
        const SizedBox(height: AppSize.s10),
        CustomTextField(
          title: localizations.name,
          isPasswordField: false,
          isMandatory: true,
          textEditingController: signupScreenState.nameTextController,
          errorText: signupScreenState.errorName,
          onChange: (value) => signupBloc.add(SignupNameChangeEvent(name: value)),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSize.s10),
        CustomTextField(
          title: localizations.email,
          isPasswordField: false,
          isMandatory: true,
          textEditingController: signupScreenState.emailTextController,
          errorText: signupScreenState.errorEmail,
          onChange: (value) => signupBloc.add(SignupEmailChangeEvent(email: value)),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSize.s10),
        CustomTextField(
          title: localizations.password,
          isPasswordField: signupScreenState.showPassword,
          isMandatory: true,
          textEditingController: signupScreenState.passwordTextController,
          onShowPassword: () => signupBloc.add(SignupShowPasswordEvent(isVisible: signupScreenState.showPassword)),
          errorText: signupScreenState.errorPassword,
          onChange: (value) => signupBloc.add(SignupPasswordChangeEvent(password: value)),
          onSubmitted: (_) => signupBloc.add(SignupSubmitEvent(
            name: signupScreenState.nameTextController.text, 
            email: signupScreenState.emailTextController.text, 
            password: signupScreenState.passwordTextController.text
          )),
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: AppSize.s24),
        CustomButton(
          title: localizations.signup,
          titleSize: AppSize.s16, 
          onTap: () => signupBloc.add(SignupSubmitEvent(
            name: signupScreenState.nameTextController.text, 
            email: signupScreenState.emailTextController.text, 
            password: signupScreenState.passwordTextController.text
          ))
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSize.s15),
          child: Align(
            alignment: Alignment.center,
            child: CustomText(
              title: 'Or', 
              textStyle: getRegularStyle(
                color: AppColors.grey, 
                fontSize: AppSize.s14
              ),
            ),
          ),
        ),
        kIsWeb
        ? const GoogleSigninCustomButton(key: Key(AppStrings.continueWithGoogle))
        : GoogleSigninCustomButton(onTap: () => signupBloc.add(SignupWithGoogleEvent())),
        const SizedBox(height: AppSize.s20),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              title: '${localizations.alreadyHaveAnAccount}  ', 
              textStyle: getMediumStyle(
                color: Helper.isDark 
                ? AppColors.white.withValues(alpha: 0.8) 
                : AppColors.black
              ),
            ),
            CustomInkWellWidget(
              onTap: () => context.pop(), 
              widget: CustomText(
                title: localizations.login, 
                textStyle: getSemiBoldStyle(fontSize: AppSize.s14, color: AppColors.primaryColor)
              ),
            ),
          ],
        ),
      ],
    );
  }
}