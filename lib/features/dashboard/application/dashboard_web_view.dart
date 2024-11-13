part of 'dashboard_screen.dart';

class DashboardWebView extends StatelessWidget {

  final DashboardBloc dashboardBloc;
  final DashboardScreenState dashboardScreenState;

  const DashboardWebView({
    super.key,
    required this.dashboardBloc,
    required this.dashboardScreenState
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: context.screenWidth * 0.28,
          decoration: const BoxDecoration(
            border: Border(right: BorderSide(
              width: AppSize.s05, 
              color: AppColors.grey
            ))
          ),
          child: Column(
            children: [
              Container(
                height: kToolbarHeight - 5,
                width: double.maxFinite,
                color: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: AppSize.s16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      title: 'Contacts',
                      textStyle: getSemiBoldStyle(),
                    ),
                    const SizedBox()
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    dashboardScreenState.isLoading
                    ? const Center(child: CircularProgressIndicator())
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
                    Positioned(
                      bottom: 20.0,
                      right: 20.0,
                      child: FloatingActionButton.extended(
                        onPressed: () => debugPrint('Click here to add new user'),
                        label: const CustomText(title: "New User"),
                        icon: const Icon(Icons.add, color: AppColors.white),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                height: kToolbarHeight - 5,
                width: double.maxFinite,
                color: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: AppSize.s16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      title: 'Abhishek',
                      textStyle: getSemiBoldStyle(),
                    ),
                    const SizedBox()
                  ],
                ),
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 500),
          child: Container(
            width: context.screenWidth * 0.28,
            color: AppColors.primaryColor,
            child: Column(
              children: [

              ],
            ),
          ),
        ),
      ],
    );
  }
}