import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../widgets/custom_text_button.dart';
import '../../../features/dashboard/application/bloc/dashboard_event.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_extension_method.dart';
import '../../../widgets/custom_outlined_button.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_style.dart';
import '../../../constants/app_size.dart';
import '../../../widgets/custom_text.dart';
import '../../../features/dashboard/application/bloc/dashboard_bloc.dart';
import '../../../features/dashboard/application/bloc/dashboard_state.dart';
import '../../../features/dashboard/domain/user_model.dart';
import '../../../widgets/custom_empty_widget.dart';
import '../../../utils/helper.dart';
import '../../../widgets/custom_text_field.dart';
import 'add_user_dialog.dart';

class DashboardScreen extends StatefulWidget{
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>  with Helper {

  List<UserModel> allUsers = [];
  var isLoading = true;
  AppLocalizations? _localizations;
  late DashboardBloc _dashboardBloc;//US Phone Number Format
  var maskFormatter = MaskTextInputFormatter(
    mask: '####-###-###',
    filter: {"#": RegExp(r'[0-9]')}
  );

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_) => DashboardBloc(),
      child: Builder(
        builder: (context) {
          _dashboardBloc = context.read<DashboardBloc>();
          return BlocConsumer<DashboardBloc, DashboardState>(
            listener: (context, state) {
              switch (state.runtimeType) {
                case DashboardFailedState:
                  hideLoadingDialog(context: context);
                  state = state as DashboardFailedState;
                  showSnackBar(context: context, title: state.title, message: state.message);
                  break;
                case DashboardAllUserState:
                  isLoading = false;
                  break;
                case DashboardSuccessState:
                  hideLoadingDialog(context: context);
                  break;
                default:
              }
            },
            builder: (context, state) {
              switch (state.runtimeType) {
                case DashboardAllUserState:
                  state = state as DashboardAllUserState;
                  allUsers.clear();
                  allUsers.addAll(state.allUser);
                  break;
                default:
              }
              return Stack(
                children: [
                  isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : allUsers.isNotEmpty
                  ? ListView.builder(
                      itemCount: allUsers.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (_, index) {
                        var data = allUsers[index];
                        return Column(
                          children: [
                            InkWell(
                              onTap: () => context.push(AppRoutes.transactionScreen, extra: data),
                              child: Ink(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSize.s16,
                                  vertical: AppSize.s14
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(1.5),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: AppColors.primaryColor, width: AppSize.s1)
                                          ),
                                          child: ClipOval(
                                            child: SizedBox.fromSize(
                                              size: const Size.fromRadius(AppSize.s18),
                                              child: data.profileImg.isEmpty
                                              ? const Center(child: Icon(AppIcons.personIcon, size: AppSize.s24, color: AppColors.primaryColor))
                                              : data.profileImg.isNetworkImage
                                                ? Image.network(
                                                    data.profileImg,
                                                    loadingBuilder: (context, child, loading){
                                                    if(loading == null){
                                                      return child;
                                                    } else {
                                                      return const Center(
                                                        child: Padding(
                                                          padding: EdgeInsets.all(AppSize.s6),
                                                          child: CircularProgressIndicator(strokeWidth: AppSize.s1)
                                                        ),
                                                      );
                                                    }
                                                    }, 
                                                    fit: BoxFit.cover
                                                  )
                                                : Image.file(File(data.profileImg), fit: BoxFit.cover)
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: AppSize.s10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              title: data.name, 
                                              textStyle: getSemiBoldStyle(
                                                color: Helper.isDark 
                                                ? AppColors.white.withOpacity(0.9) 
                                                : AppColors.black
                                              ),
                                            ),
                                            CustomText(
                                              title: 'Date Format',
                                              textStyle: getRegularStyle(color: AppColors.grey)
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: AppSize.s40,
                                      height: AppSize.s40,
                                      child: IconButton(
                                        onPressed: () async {
                                          var deleteStatus = await showUserInfoSheet(context, data);
                                          if(deleteStatus){
                                            if(context.mounted && await confirmationDialog(context: context, title: _localizations!.deleteUser, content: "${_localizations!.deleteUserMsg} ${data.name}", localizations: _localizations!)){
                                              _dashboardBloc.add(DashboardDeleteUserEvent(docId: data.userId));
                                            }
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.info_outline_rounded, 
                                          color: AppColors.primaryColor,
                                          size: AppSize.s22
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              color: AppColors.grey, 
                              thickness: AppSize.s05, 
                              height: AppSize.s05
                            ),
                          ],
                        );
                      },
                    )
                  : const CustomEmptyWidget(title: AppStrings.noUserFound,icon: AppIcons.personIcon),
                  Visibility(
                    visible: !isLoading,
                    child: Positioned(
                      right: AppSize.s20,
                      bottom: AppSize.s20,
                      child: InkWell(
                        onTap: () => addUserDialog(dashboardBloc: context.read<DashboardBloc>()),
                        borderRadius: BorderRadius.circular(AppSize.s30),
                        child: Ink(
                          child: Container(
                            padding: const EdgeInsets.all(AppSize.s14),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle
                            ),
                            child: const Icon(
                              AppIcons.addIcon, 
                              color: AppColors.white, 
                              size: AppSize.s26
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          );
        }
      ),
    );
  }

  Future<bool> showUserInfoSheet(BuildContext mContext, UserModel userData) async {
    return await showModalBottomSheet(
      context: mContext, 
      builder: (_) {
        return Container(
          width: context.screenWidth,
          color: Helper.isDark ? AppColors.dialogColorDark : AppColors.white,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(AppSize.s16),
            children: [
              CustomText(
                title: _localizations!.userProfile, 
                textStyle: getMediumStyle(
                  color: Helper.isDark ? AppColors.white : AppColors.black, 
                  fontSize: AppSize.s16
                ),
              ),
              const SizedBox(height: AppSize.s18),
              CustomTextField(
                title: _localizations!.phone, 
                isPasswordField: false, 
                isEnabled: false,
                isMandatory: true,
                textInputFormatter: [maskFormatter],
                textEditingController: TextEditingController(text: maskFormatter.maskText(userData.phone)),
              ),
              CustomTextField(
                title: _localizations!.name, 
                isPasswordField: false, 
                isEnabled: false,
                isMandatory: true,
                textEditingController: TextEditingController(text: userData.name),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomOutlinedButton(
                      onPressed: () => context.pop(true),
                      title: _localizations!.deleteUser, 
                      icon: AppIcons.deleteIcon,
                      isSelected: true,
                      foregroundColor: AppColors.red,
                      backgroundColor: AppColors.red.withOpacity(0.2),
                    ),
                  ),
                  const SizedBox(width: AppSize.s10),
                  Expanded(
                    child: CustomTextButton(
                        onPressed: () {
                          context.pop(false);
                          context.push(AppRoutes.profileScreen, extra: userData.userId);
                        },
                        title: _localizations!.viewProfile,
                        isSelected: true,
                        foregroundColor: AppColors.white,
                        backgroundColor: AppColors.primaryColor,
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                  )
                ],
              ),
            ],
          ),
        );
      }
    ) ?? false;
  }

  void addUserDialog({required DashboardBloc dashboardBloc}) {
    showDialog(
      context: context, 
      builder: (_) => const AddUserDialog()
    );
  }
  
}