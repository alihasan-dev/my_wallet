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
          onChange: (value) => context.read<SignupBloc>().add(SignupNameChangeEvent(name: value)),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSize.s10),
        CustomTextField(
          title: localizations.email,
          isPasswordField: false,
          isMandatory: true,
          textEditingController: signupScreenState.emailTextController,
          errorText: signupScreenState.errorEmail,
          onChange: (value) => context.read<SignupBloc>().add(SignupEmailChangeEvent(email: value)),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSize.s10),
        CustomTextField(
          title: localizations.password,
          isPasswordField: signupScreenState.showPassword,
          isMandatory: true,
          textEditingController: signupScreenState.passwordTextController,
          onShowPassword: () => context.read<SignupBloc>().add(SignupShowPasswordEvent(isVisible: signupScreenState.showPassword)),
          errorText: signupScreenState.errorPassword,
          onChange: (value) => context.read<SignupBloc>().add(SignupPasswordChangeEvent(password: value)),
          onSubmitted: (_) => context.read<SignupBloc>().add(SignupSubmitEvent(
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
          onTap: () => context.read<SignupBloc>().add(SignupSubmitEvent(
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
        GoogleSigninCustomButton(onTap: () => context.read<SignupBloc>().add(SignupWithGoogleEvent())),
        // InkWell(
        //   onTap: () => context.read<SignupBloc>().add(SignupWithGoogleEvent()),
        //   borderRadius: BorderRadius.circular(AppSize.s5),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(AppSize.s5),
        //       border: Border.all(color: AppColors.grey.withValues(alpha: 0.4))
        //     ),
        //     padding: const EdgeInsets.symmetric(vertical: AppSize.s12),
        //     child: Row(
        //       spacing: AppSize.s10,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         CustomImageWidget(
        //           imageUrl: AppImages.googleIcon, 
        //           imageSize: AppSize.s22,
        //           strokeWidth: AppSize.s0,
        //           borderWidth: AppSize.s0,
        //           padding: AppSize.s0,
        //           borderColor: AppColors.transparent,
        //         ),
        //         CustomText(title: 'Continue with Google')
        //       ],
        //     ),
        //   ),
        // ),
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