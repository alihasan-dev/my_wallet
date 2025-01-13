import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/constants/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../features/dashboard/application/bloc/dashboard_bloc.dart';
import '../../../constants/app_style.dart';
import '../../../widgets/custom_button.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_size.dart';
import '../../../widgets/custom_text.dart';
import '../../../utils/helper.dart';


class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {

  var emailTextController = TextEditingController();
  var nameTextController = TextEditingController();
  String errorName = '';
  String errorEmail = '';
  bool isFirstOpen = true;
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s6)),
        content: BlocConsumer<DashboardBloc, DashboardState>(
          builder: (context, state){
            switch (state) {
              case DashboardEmailFieldState _:
                errorEmail = state.emailMessage;
                break;
              case DashboardNameFieldState _:
                errorName = state.nameMessage;
                break;
              default:
            }
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
                          icon: const Icon(Icons.clear),
                          visualDensity: VisualDensity.compact,
                          tooltip: _localizations!.close,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: AppSize.s8),
                  TextField(
                    controller: nameTextController,
                    onChanged: (value) => context.read<DashboardBloc>().add(DashboardNameChangeEvent(name: value)),
                    decoration: InputDecoration(
                      hintText: AppStrings.name,
                      errorText: errorName.isNotEmpty
                      ? errorName
                      : null,
                      label: CustomText(
                        title: '${_localizations!.name} *',
                        textColor: Helper.isDark 
                        ? AppColors.white.withValues(alpha: 0.8)
                        : AppColors.black
                      ),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: AppSize.s05, color: Helper.isDark ? AppColors.grey : AppColors.black))
                    ),
                  ),
                  const SizedBox(height: AppSize.s12),
                  TextField(
                    controller: emailTextController,
                    onChanged: (value) => context.read<DashboardBloc>().add(DashboardEmailChangeEvent(email: value)),
                    decoration: InputDecoration(
                      hintText: AppStrings.email,
                      errorText: errorEmail.isNotEmpty
                      ? errorEmail
                      : null,
                      label: CustomText(
                        title: '${_localizations!.email} *',
                        textColor: Helper.isDark 
                        ? AppColors.white.withValues(alpha: 0.8)
                        : AppColors.black
                      ),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: AppSize.s05, color: Helper.isDark ? AppColors.grey : AppColors.black))
                    ),
                  ),
                  const SizedBox(height: AppSize.s15),
                  CustomButton(
                    title: _localizations!.addUser, 
                    onTap: () => context.read<DashboardBloc>().add(DashboardAddUserEvent(name: nameTextController.text, email: emailTextController.text)),
                    titleSize: AppSize.s15,
                  ),
                ],
              ),
            );
          }, 
          listener: (_, state){
            switch (state) {
              case DashboardAllUserState _:
                if(!isFirstOpen){
                  Navigator.pop(context);
                }
                isFirstOpen = false;
                break;
              default:
            }
          }
        ),
      ),
    );
  }
}