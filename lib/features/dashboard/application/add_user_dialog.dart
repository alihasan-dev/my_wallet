import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/helper.dart';
import '../../../constants/app_theme.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_style.dart';
import '../../../utils/text_input_formatter.dart';
import '../../../widgets/custom_button.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_size.dart';
import '../../../widgets/custom_checkbox_widget.dart';
import '../../../widgets/custom_text.dart';
import '../../../features/dashboard/application/bloc/dashboard_bloc.dart';
import '../../../widgets/custom_text_field.dart';

class AddUserDialog extends StatefulWidget {
  
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {

  var emailTextController = TextEditingController();
  var phoneTextController = TextEditingController();
  var nameTextController = TextEditingController();
  String errorName = '';
  String errorEmail = '';
  String errorPhone = '';
  bool isFirstOpen = true;
  bool isArchived = false;
  AppLocalizations? _localizations;  

  @override
  Widget build(BuildContext context) {
    _localizations = AppLocalizations.of(context)!;
    return BlocProvider<DashboardBloc>(
      create: (context) => DashboardBloc(),
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(AppSize.s15),
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSize.s15),
        backgroundColor: Helper.isDark 
        ? AppColors.dialogColorDark 
        : AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s10)),
        content: BlocConsumer<DashboardBloc, DashboardState>(
          builder: (context, _) {
            return SizedBox(
              width: MyAppTheme.columnWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: _localizations!.addUser,
                        textStyle: getSemiBoldStyle(),
                      ),
                      Transform.translate(
                        offset: const Offset(10, 0),
                        child: IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(AppIcons.clearIcon),
                          visualDensity: VisualDensity.compact,
                          tooltip: _localizations!.close,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSize.s10),
                  CustomTextField(
                    title: _localizations!.name,
                    isPasswordField: false,
                    isMandatory: true,
                    textEditingController: nameTextController,
                    errorText: errorName,
                    onChange: (value) => context.read<DashboardBloc>().add(DashboardNameChangeEvent(name: value)),
                    textInputAction: TextInputAction.next,
                    textInputFormatter: [NameInputFormatter()],
                    animatedError: false
                  ),
                  const SizedBox(height: AppSize.s16),
                  CustomTextField(
                    title: _localizations!.phone,
                    isPasswordField: false,
                    isMandatory: true,
                    textEditingController: phoneTextController,
                    errorText: errorPhone,
                    onChange: (value) => context.read<DashboardBloc>().add(DashboardPhoneChangeEvent(phone: phoneTextController.text.replaceAll('-', ''))),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    textInputFormatter: [IndianMobileNumberFormatter()],
                    animatedError: false,
                    prefix: Text(
                      '+91 ',
                      style: TextStyle(
                        color: Helper.isDark 
                        ? AppColors.white 
                        : AppColors.black,
                        fontSize: AppSize.s14
                      ),
                    ),
                    hintStyle: TextStyle(fontSize: AppSize.s14, color: AppColors.grey),
                  ),
                  const SizedBox(height: AppSize.s16),
                  Row(
                    spacing: AppSize.s8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCheckBoxWidget(
                        value: isArchived, 
                        onChange: (value) {
                          context.read<DashboardBloc>().add(DashboardArchieveUserEvent(
                            isArchievedUser: value ?? false
                          ));
                        }
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: AppSize.s2,
                          children: [
                            CustomText(title: _localizations!.create_archived_user_label),
                            CustomText(
                              title: _localizations!.archived_user_hint,
                              textStyle: getLightStyle(
                                fontSize: 12,
                                color: AppColors.grey
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSize.s18),
                  CustomButton(
                    title: _localizations!.add, 
                    onTap: () => context.read<DashboardBloc>().add(DashboardAddUserEvent(
                      name: nameTextController.text, 
                      email: emailTextController.text,
                      phone: phoneTextController.text.replaceAll('-', ''),
                      isArchived: isArchived
                    )),
                    titleSize: AppSize.s15,
                  ),
                ],
              ),
            );
          }, 
          listener: (_, state) {
            switch (state) {
              case DashboardAllUserState _:
                if(!isFirstOpen) Navigator.pop(context);
                isFirstOpen = false;
                break;
              case DashboardEmailFieldState _:
                errorEmail = state.emailMessage;
                break;
              case DashboardPhoneFieldState _:
                errorPhone = state.phoneMessage;
                break;
              case DashboardNameFieldState _:
                errorName = state.nameMessage;
                break;
              case DashboardArchieveUserState _:
                isArchived = state.isArchievedUser;
                break;
              default:
            }
          }
        ),
      ),
    );
  }
}