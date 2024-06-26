import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/dashboard_bloc.dart';
import '../../../widgets/custom_button.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_size.dart';
import '../../../widgets/custom_text.dart';


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

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardBloc>(
      create: (context) => DashboardBloc(),
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(AppSize.s15),
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSize.s15),
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s8)),
        content: BlocConsumer<DashboardBloc, DashboardState>(
          builder: (context, state){
            switch (state.runtimeType) {
              case DashboardEmailFieldState:
                state = state as DashboardEmailFieldState;
                errorEmail = state.emailMessage;
                break;
              case DashboardNameFieldState:
                state = state as DashboardNameFieldState;
                errorName = state.nameMessage;
                break;
              default:
            }
            return SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameTextController,
                    onChanged: (value) => context.read<DashboardBloc>().add(DashboardNameChangeEvent(name: value)),
                    decoration: InputDecoration(
                      hintText: AppStrings.name,
                      errorText: errorName.isNotEmpty
                      ? errorName
                      : null,
                      label: const CustomText(title: 'Name *',textColor: AppColors.black),
                      border: const OutlineInputBorder()
                    ),
                  ),
                  const SizedBox(height: AppSize.s10),
                  TextField(
                    controller: emailTextController,
                    onChanged: (value) => context.read<DashboardBloc>().add(DashboardEmailChangeEvent(email: value)),
                    decoration: InputDecoration(
                      hintText: AppStrings.email,
                      errorText: errorEmail.isNotEmpty
                      ? errorEmail
                      : null,
                      label: const CustomText(title: 'Email *',textColor: AppColors.black),
                      border: const OutlineInputBorder()
                    ),
                  ),
                  const SizedBox(height: AppSize.s10),
                  CustomButton(
                    title:  AppStrings.addUser, 
                    onTap: () => context.read<DashboardBloc>().add(DashboardAddUserEvent(name: nameTextController.text, email: emailTextController.text))
                  ),
                ],
              ),
            );
          }, 
          listener: (_, state){
            switch (state.runtimeType) {
              case DashboardAllUserState:
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