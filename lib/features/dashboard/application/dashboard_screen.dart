import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../widgets/custom_image_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_extension_method.dart';
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
import 'add_user_dialog.dart';

class DashboardScreen extends StatefulWidget{
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>  with Helper {

  List<UserModel> allUsers = [];
  bool isLoading = true;
  bool showUnverified = true;

  var maskFormatter = MaskTextInputFormatter(
    mask: '####-###-###',
    filter: {"#": RegExp(r'[0-9]')}
  );
  late DateFormat dateFormat;

  @override
  void didChangeDependencies() {
    dateFormat = DateFormat.yMMMd();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_) => DashboardBloc(),
      child: Builder(
        builder: (context) {
          return BlocConsumer<DashboardBloc, DashboardState>(
            listener: (context, state) {
              switch (state) {
                case DashboardFailedState _:
                  hideLoadingDialog(context: context);
                  showSnackBar(context: context, title: state.title, message: state.message);
                  break;
                case DashboardAllUserState _:
                  isLoading = false;
                  allUsers.clear();
                  allUsers.addAll(state.allUser);
                  break;
                case DashboardSuccessState _:
                  hideLoadingDialog(context: context);
                  break;
                default:
              }
            },
            builder: (context, state) {
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
                                        CustomImageWidget(
                                          imageUrl: data.profileImg, 
                                          imageSize: AppSize.s18,
                                          circularPadding: AppSize.s5,
                                          strokeWidth: AppSize.s1,
                                          padding: 1.5,
                                          borderWidth: 1.5,
                                        ),
                                        const SizedBox(width: AppSize.s10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                CustomText(
                                                  title: data.name, 
                                                  textStyle: getSemiBoldStyle(),
                                                ),
                                                Visibility(
                                                  visible: !data.isUserVerified,
                                                  child: Container(
                                                    margin: const EdgeInsets.only(left: AppSize.s8),
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 1.8,
                                                      horizontal: AppSize.s5
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.amber.withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(AppSize.s4)
                                                    ),
                                                    child: CustomText(
                                                      title: 'Test',
                                                      textStyle: getRegularStyle(
                                                        color: Colors.amber,
                                                        fontSize: AppSize.s14
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Visibility(
                                              visible: !data.lastTransactionDate.isNegative,
                                              child: CustomText(
                                                title: data.lastTransactionDate.isNegative
                                                ? ''
                                                : dateFormat.format(DateTime.fromMillisecondsSinceEpoch(data.lastTransactionDate)),
                                                textStyle: getRegularStyle(color: AppColors.grey)
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    CustomText(
                                      title: data.amount.amountFormat(type: data.type),
                                      textStyle: getMediumStyle(
                                        color: data.type == AppStrings.transfer
                                        ? AppColors.red
                                        : AppColors.green
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
                        onTap: () => addUserDialog(),
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

  void addUserDialog() {
    showDialog(
      context: context, 
      builder: (_) => const AddUserDialog()
    );
  }
  
}