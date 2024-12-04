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
    return Container(
      width: double.maxFinite,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(
          width: AppSize.s05, 
          color: AppColors.grey
        ))
      ),
      child: Column(
        children: [
          Container(
            height: AppBar().preferredSize.height,
            width: double.maxFinite,
            color: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: AppSize.s14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  title: 'Contacts',
                  textStyle: getBoldStyle(color: AppColors.white),
                ),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  // offset: const Offset(-130, 0),
                  position: PopupMenuPosition.under,
                  iconColor: AppColors.white,
                  menuPadding: const EdgeInsets.symmetric(vertical: AppSize.s5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s10)),
                  itemBuilder: (_) {
                    return <PopupMenuEntry<String>> [
                      PopupMenuItem<String>(
                        value: AppStrings.settings,
                        padding: const EdgeInsets.only(left: AppSize.s10, right: AppSize.s40),
                        child: ListTile(
                          visualDensity: VisualDensity.compact,
                          leading: const Icon(AppIcons.settingsIcon),
                          title: CustomText(title: 'Settings', textStyle: getMediumStyle()),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: AppStrings.logout,
                        padding: const EdgeInsets.only(left: AppSize.s10, right: AppSize.s40),
                        child: ListTile(
                          visualDensity: VisualDensity.compact,
                          leading: const Icon(AppIcons.logoutIcon),
                          title: CustomText(title: 'Logout', textStyle: getMediumStyle()),
                        ),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    switch (value) {
                      case AppStrings.settings:
                        context.go('/dashboard/settings');
                        break;
                      case AppStrings.logout:
                        dashboardScreenState.onClickLogout(context: context);
                        break;
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.s8,
              vertical: AppSize.s5
            ),
            child: CupertinoTheme(
              data: CupertinoThemeData(brightness: Helper.isDark ? Brightness.dark : Brightness.light),
              child: CupertinoSearchTextField(
                controller: dashboardScreenState.searchTextController,
                onChanged: (value) => dashboardBloc.add(DashboardSearchEvent(text: value)),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                dashboardScreenState.isLoading
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
                            onTap: () => context.go('/dashboard/${data.userId}', extra: data),
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
                  bottom: 16.0,
                  right: 16.0,
                  child: FloatingActionButton.extended(
                    onPressed: dashboardScreenState.addUserDialog,
                    backgroundColor: AppColors.primaryColor,
                    label: CustomText(title: "New User", textStyle: getMediumStyle(fontSize: AppSize.s16, color: AppColors.white)),
                    icon: const Icon(Icons.add, color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}