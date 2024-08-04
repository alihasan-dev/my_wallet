import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

class DashboardScreen extends StatefulWidget{
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>  with Helper {

  List<UserModel> allUsers = [];
  bool isLoading = true;
  AppLocalizations? _localizations;

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
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
                  itemBuilder: (_, index){
                    var data = allUsers[index];
                    return InkWell(
                      onTap: () => context.push(AppRoutes.transactionScreen, extra: data),
                      child: Ink(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.s18,
                          vertical: AppSize.s15,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppColors.grey, width: AppSize.s05))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              title: data.name, 
                              textStyle: getSemiBoldStyle(
                                color: Helper.isDark 
                                ? AppColors.white.withOpacity(0.9) 
                                : AppColors.black
                              ),
                            ),
                            SizedBox(
                              width: AppSize.s40,
                              height: AppSize.s40,
                              child: IconButton(
                                onPressed: () async {
                                  var deleteStatus = await showUserInfoSheet(context, data);
                                  if(deleteStatus){
                                    if(context.mounted && await confirmationDialog(context: context, title: _localizations!.deleteUser, content: "${_localizations!.deleteUserMsg} ${data.name}", localizations: _localizations!)){
                                      context.read<DashboardBloc>().add(DashboardDeleteUserEvent(docId: data.userId));
                                    }
                                  }
                                },
                                icon: const Icon(
                                  Icons.info_outline_rounded, 
                                  color: AppColors.primaryColor
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                        padding: const EdgeInsets.all(AppSize.s15),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle
                        ),
                        child: const Icon(
                          AppIcons.addIcon, 
                          color: AppColors.white, 
                          size: AppSize.s28
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
    return await showModalBottomSheet(
      context: mContext, 
      builder: (_) {
        return Container(
          width: context.screenWidth,
          color: Helper.isDark ? AppColors.dialogColorDark : AppColors.white,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(AppSize.s20),
            children: [
              CustomText(
                title: _localizations!.userProfile, 
                textStyle: getMediumStyle(
                  color: Helper.isDark ? AppColors.white : AppColors.black, 
                  fontSize: AppSize.s16
                ),
              ),
              const SizedBox(height: AppSize.s20),
              CustomTextField(
                title: _localizations!.email, 
                isPasswordField: false, 
                isEnabled: false,
                isMandatory: true,
                textEditingController: TextEditingController(text: userData.email),
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