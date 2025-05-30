import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_extension_method.dart';
import '../../../widgets/custom_text_button.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_style.dart';
import '../../../utils/helper.dart';
import '../../../features/forgot_password/application/bloc/forgot_password_bloc.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_size.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {

  const ForgotPasswordScreen({super.key});

  @override
  State createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with Helper {

  late TextEditingController _emailTextController;
  String errorEmail = '';
  late ForgotPasswordBloc _forgotPasswordBloc;
  AppLocalizations? _localizations;

  @override
  void initState() {
    _forgotPasswordBloc = context.read<ForgotPasswordBloc>();
    _emailTextController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        toolbarHeight: AppSize.s0
      ),
      body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          switch (state) {
            case ForgotPasswordFailedState _:
              hideLoadingDialog(context: context);
              showSnackBar(context: context, title: state.title, message: state.message);
              break;
            case ForgotPasswordSuccessState _:
              hideLoadingDialog(context: context);
              showSnackBar(context: context, title: state.message, color: AppColors.green);
              break;
            case ForgotPasswordLoadingState _:
              showLoadingDialog(context: context);
              break;
            case ForgotPasswordEmailFieldState _:
              errorEmail = state.message;
              break;
            default:
          }
        },
        builder: (_, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 600) {
                return Center(
                  child: SizedBox(
                    width: MyAppTheme.columnWidth + AppSize.s30,
                    child: Center(child: mainContent(context: context, isWeb: true)),
                  ),
                );
              } else {
                return mainContent(context: context);
              }
            }
          );
        }
      ),
    );
  }

  Widget mainContent({required BuildContext context, bool isWeb = false}) {
    return ListView(
      shrinkWrap: true,
      padding: isWeb 
      ? EdgeInsets.zero
      : const EdgeInsets.symmetric(horizontal: AppSize.s28, vertical: AppSize.s28),
      children: [
        Offstage(
          offstage: isWeb ? true : false,
          child: Row(
            children: [
              Transform.translate(
                offset: const Offset(-8, 0),
                child: IconButton(
                  onPressed: () => context.pop(), 
                  icon: Transform.translate(
                    offset: Offset(!kIsWeb && Platform.isIOS ? AppSize.s4 : 0, 0),
                    child: Icon(
                      !kIsWeb && Platform.isIOS
                      ? AppIcons.backArrowIconIOS
                      : AppIcons.backArrowIcon
                    ),
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.grey.withValues(alpha: 0.2)
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(child: Image.asset(AppImages.appImage, height: 90, width: 90)),
        CustomText(
          title: _localizations!.forgotPassword, 
          textStyle: getSemiBoldStyle(
            color: Helper.isDark
            ? AppColors.white.withValues(alpha: 0.9)
            : AppColors.black,
            fontSize: AppSize.s18
          ),
          textAlign: TextAlign.center
        ),
        const SizedBox(height: AppSize.s8),
        CustomText(
          title: _localizations!.forgotPasswordMsg, 
          textColor: Helper.isDark
          ? AppColors.white.withValues(alpha: 0.9)
          : AppColors.black,
          textAlign: TextAlign.center
        ),
        const SizedBox(height: AppSize.s20),
        CustomTextField(
          title: _localizations!.email,
          isPasswordField: false,
          isMandatory: true,
          textEditingController: _emailTextController,
          errorText: errorEmail,
          onChange: (value) => _forgotPasswordBloc.add(ForgotPasswordEmailChangeEvent(value: value)),
          onSubmitted: (value) => _forgotPasswordBloc.add(ForgotPasswordSubmitEvent(email: value)),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSize.s12),
        CustomButton(
          title: _localizations!.send,
          titleSize: AppSize.s16, 
          verticalPadding: AppSize.s10,
          onTap: errorEmail.isNotEmpty || _emailTextController.text.isBlank
          ? null
          : () => _forgotPasswordBloc.add(ForgotPasswordSubmitEvent(email: _emailTextController.text))
        ),
        const SizedBox(height: AppSize.s18),
        Offstage(
          offstage: isWeb ? false : true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextButton(
                title: _localizations!.backToLogin,
                onPressed: context.pop,
                isShapeStadium: true,
                foregroundColor: AppColors.primaryColor,
                backgroundColor: AppColors.transparent,
                horizontalPadding: AppSize.s12,
                isSelected: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}