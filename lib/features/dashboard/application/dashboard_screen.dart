import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
import '../../../features/dashboard/domain/user_model.dart';
import '../../../widgets/custom_empty_widget.dart';
import '../../../utils/helper.dart';
import '../../../widgets/custom_text_field.dart';
import 'add_user_dialog.dart';

class DashboardScreen extends StatefulWidget {

  const DashboardScreen({super.key});

  @override
  State createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>  with Helper {

  List<UserModel> allUsers = [];
  bool isLoading = true;
  late TextEditingController emailTextController;
  late TextEditingController nameTextController;

  @override
  void initState() {
    emailTextController = TextEditingController();
    nameTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_) => DashboardBloc(),
      child: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          switch (state.runtimeType) {
            case DashboardFailedState:
              hideLoadingDialog(context: context);
              state = state as DashboardFailedState;
              showSnackBar(
                context: context, 
                title: state.title, 
                message: state.message
              );
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
              ? ListView.separated(
                  itemCount: allUsers.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (_, index){
                    var data = allUsers[index];
                    return InkWell(
                      onTap: () => context.push(AppRoutes.transactionScreen, extra: data),
                      child: Ink(
                        padding: const EdgeInsets.all(AppSize.s18),
                        color: AppColors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              title: data.name, 
                              textStyle: getSemiBoldStyle(color: AppColors.black)
                            ),
                            SizedBox(
                              width: AppSize.s40,
                              height: AppSize.s40,
                              child: IconButton(
                                onPressed: () async {
                                  var deleteStatus = await showUserInfoSheet(context, data);
                                  if(deleteStatus) {
                                    if(context.mounted && await confirmationDialog(context: context, title: AppStrings.deleteUser, content: "${AppStrings.deleteUserMsg} ${data.name}")){
                                      context.read<DashboardBloc>().add(DashboardDeleteUserEvent(docId: data.userId));
                                    }
                                  }
                                },
                                icon: const Icon(Icons.info_outline_rounded, color: AppColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_,__) => const Divider(
                    color: AppColors.grey, 
                    thickness: AppSize.s05, 
                    height: AppSize.s05
                  ),
                )
              : const CustomEmptyWidget(title: AppStrings.noUserFound, icon: AppIcons.personIcon),
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
                        padding: const EdgeInsets.all(AppSize.s16),
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
      ),
    );
  }

  Future<bool> showUserInfoSheet(BuildContext mContext, UserModel userData) async {
    emailTextController.text = userData.email;
    nameTextController.text = userData.name;
    return await showModalBottomSheet(
      context: mContext, 
      builder: (_) {
        return Container(
          width: context.screenWidth,
          color: AppColors.white,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(AppSize.s20),
            children: [
              CustomText(
                title: AppStrings.userProfile, 
                textStyle: getMediumStyle(
                  color: AppColors.black, 
                  fontSize: AppSize.s16
                ),
              ),
              const SizedBox(height: AppSize.s20),
              CustomTextField(
                title: AppStrings.email, 
                isPasswordField: false, 
                isEnabled: false,
                isMandatory: true,
                textEditingController: emailTextController,
              ),
              CustomTextField(
                title: AppStrings.name, 
                isPasswordField: false, 
                isEnabled: false,
                isMandatory: true,
                textEditingController: nameTextController,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomOutlinedButton(
                      onPressed: () => context.pop(true),
                      title: AppStrings.deleteUser, 
                      icon: AppIcons.deleteIcon,
                      isSelected: true,
                      foregroundColor: AppColors.red,
                      backgroundColor: AppColors.red.withOpacity(0.2),
                    ),
                  ),
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