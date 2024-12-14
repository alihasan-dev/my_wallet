part of 'dashboard_screen.dart';

class DashboardMobileView extends StatelessWidget {
  final DashboardBloc dashboardBloc;
  final DashboardScreenState dashboardScreenState;

  const DashboardMobileView({
    super.key,
    required this.dashboardBloc,
    required this.dashboardScreenState
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        !dashboardScreenState.isLoading
        ? const Center(child: CircularProgressIndicator.adaptive())
        : dashboardScreenState.allUsers.isNotEmpty
        ? ListView.builder(
            itemCount: dashboardScreenState.allUsers.length,
            padding: EdgeInsets.zero,
            itemBuilder: (_, index) {
              var data = dashboardScreenState.allUsers[index];
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
                                      : dashboardScreenState.dateFormat.format(DateTime.fromMillisecondsSinceEpoch(data.lastTransactionDate)),
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
          visible: !dashboardScreenState.isLoading,
          child: Positioned(
            right: AppSize.s20,
            bottom: AppSize.s20,
            child: InkWell(
              onTap: () => dashboardScreenState.addUserDialog(),
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
}