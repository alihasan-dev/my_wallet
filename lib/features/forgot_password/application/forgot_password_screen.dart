import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/forgot_password/application/bloc/forgot_password_event.dart';
import '../../../features/forgot_password/application/bloc/forgot_password_bloc.dart';
import '../../../features/forgot_password/application/bloc/forgot_password_state.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_size.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {

  const ForgotPasswordScreen({super.key});

  @override
  State createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  late TextEditingController emailTextController;
  String errorEmail = '';

  @override
  void initState() {
    emailTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordBloc(),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            // switch (state.runtimeType) {
            //   case LoginFailedState:
            //     hideLoadingDialog(context: context);
            //     state = state as LoginFailedState;
            //     showSnackBar(context: context, title: state.title, message: state.message);
            //     break;
            //   case LoginLoadingState:
            //     showLoadingDialog(context: context);
            //     break;
            //   case LoginSuccessState:
            //     hideLoadingDialog(context: context);
            //     context.go(AppRoutes.homeScreen);
            //     break;
            //   default:
            // }
          },
          builder: (context, state) {
            switch (state.runtimeType) {
              case ForgotPasswordEmailFieldState:
                state = state as ForgotPasswordEmailFieldState;
                errorEmail = state.message;
                break;
              default:
            }
            return ListView(
              padding: const EdgeInsets.all(AppSize.s28),
              children: [
                const SizedBox(height: AppSize.s10),
                Center(child: Image.asset(AppImages.appImage, height: 80, width: 80)),
                const SizedBox(height: AppSize.s20),
                const CustomText(
                  title: AppStrings.forgotPasswordMsg, 
                  textColor: AppColors.black,
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: AppSize.s20),
                CustomTextField(
                  title: AppStrings.email,
                  isPasswordField: false,
                  isMandatory: true,
                  textEditingController: emailTextController,
                  errorText: errorEmail,
                  onChange: (value) => context.read<ForgotPasswordBloc>().add(ForgotPasswordEmailChangeEvent(value: value)),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSize.s10),
                CustomButton(
                  title: AppStrings.continueString,
                  titleSize: AppSize.s16, 
                  onTap: () => context.read<ForgotPasswordBloc>().add(ForgotPasswordSubmitEvent(email: emailTextController.text))
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}