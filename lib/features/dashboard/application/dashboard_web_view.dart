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
    final localizations = AppLocalizations.of(context)!;
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
          Offstage(
            offstage: kIsWeb,
            child: Container(
              height: context.statusBarHeight, 
              color: AppColors.primaryColor
            ),
          ),
          Container(
            height: AppBar().preferredSize.height,
            width: double.maxFinite,
            color: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: AppSize.s14),
            child: dashboardScreenState.selectedUserCount > 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => dashboardBloc.add(DashboardCancelSelectedContactEvent()),
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.white
                        ),
                      ),
                      CustomText(
                        title: dashboardScreenState.selectedUserCount.toString(),
                        textStyle: getSemiBoldStyle(color: AppColors.white, fontSize: AppSize.s18)
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => dashboardBloc.add(DashboardPinnedContactEvent()),
                    icon: const Icon(Icons.push_pin_outlined, color: AppColors.white)
                  ),
                ],
              )
            : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  title: localizations.contacts,
                  textStyle: getBoldStyle(color: AppColors.white),
                ),
                IgnorePointer(
                  ignoring: dashboardScreenState.isLoading,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => dashboardBloc.add(DashboardSearchFieldEnableEvent(isSearchFieldClosed: dashboardScreenState.searchFieldEnable)),
                        color: AppColors.white,
                        icon: Icon(
                          dashboardScreenState.searchFieldEnable
                          ? Icons.clear
                          : Icons.search
                        ),
                      ),
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        position: PopupMenuPosition.under,
                        iconColor: AppColors.white,
                        menuPadding: const EdgeInsets.symmetric(vertical: AppSize.s5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s10)),
                        itemBuilder: (_) {
                          return <PopupMenuEntry<String>> [
                            PopupMenuItem<String>(
                              value: AppStrings.profile,
                              padding: const EdgeInsets.only(left: AppSize.s10, right: AppSize.s40),
                              child: ListTile(
                                visualDensity: VisualDensity.compact,
                                leading: const Icon(AppIcons.personIcon),
                                title: CustomText(title: localizations.profile, textStyle: getMediumStyle()),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: AppStrings.settings,
                              padding: const EdgeInsets.only(left: AppSize.s10, right: AppSize.s40),
                              child: ListTile(
                                visualDensity: VisualDensity.compact,
                                leading: const Icon(AppIcons.settingsIcon),
                                title: CustomText(title: localizations.settings, textStyle: getMediumStyle()),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: AppStrings.logout,
                              padding: const EdgeInsets.only(left: AppSize.s10, right: AppSize.s40),
                              child: ListTile(
                                visualDensity: VisualDensity.compact,
                                leading: const Icon(AppIcons.logoutIcon),
                                title: CustomText(title: localizations.logout, textStyle: getMediumStyle()),
                              ),
                            ),
                          ];
                        },
                        onSelected: (value) {
                          switch (value) {
                            case AppStrings.profile:
                              context.go('/dashboard/profile');
                              dashboardBloc.add(DashboardSelectedUserEvent());
                              break;
                            case AppStrings.settings:
                              context.go('/dashboard/settings');
                              dashboardBloc.add(DashboardSelectedUserEvent());
                              break;
                            case AppStrings.logout:
                              dashboardScreenState.onClickLogout(context: context);
                              break;
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: MyAppTheme.animationDuration,
            height: dashboardScreenState.searchFieldEnable ? AppSize.s36 : AppSize.s0,
            width: dashboardScreenState.searchFieldEnable ? double.maxFinite : AppSize.s0,
            margin: EdgeInsets.symmetric(
              horizontal: AppSize.s8,
              vertical: dashboardScreenState.searchFieldEnable ? AppSize.s5 : AppSize.s0
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
                            onTap: () {
                              if(dashboardScreenState.selectedUserCount == 0) {
                                context.go('/dashboard/${data.userId}', extra: data);
                                dashboardBloc.add(DashboardSelectedUserEvent(userId: data.userId));
                              } else {
                                dashboardBloc.add(DashboardSelectedContactEvent(selectedUserId: data.userId));
                              }
                            },
                            onLongPress: () => dashboardBloc.add(DashboardSelectedContactEvent(selectedUserId: data.userId)),
                            child: Ink(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.s16,
                                vertical: AppSize.s14
                              ),
                              color: dashboardScreenState.selectedUserId == null || data.userId != dashboardScreenState.selectedUserId
                              ? null
                              : AppColors.grey.withValues(alpha: 0.2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CustomImageWidget(
                                        imageUrl: data.profileImg,
                                        imageSize: AppSize.s40,
                                        circularPadding: AppSize.s5,
                                        strokeWidth: AppSize.s1,
                                        padding: 1.5,
                                        borderWidth: 1.5,
                                        isSelected: data.isSelected
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
                                                    color: Colors.amber.withValues(alpha: 0.1),
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
                                  Row(
                                    children: [
                                      CustomText(
                                        title: data.amount.amountFormat(type: data.type),
                                        textStyle: getMediumStyle(
                                          color: data.type == AppStrings.transfer
                                          ? AppColors.red
                                          : AppColors.green
                                        ),
                                      ),
                                      AnimatedSize(
                                        duration: MyAppTheme.animationDuration,
                                        child: !data.isPinned
                                        ? const SizedBox.shrink()
                                        : const Row(
                                          children: [
                                            SizedBox(width: AppSize.s5),
                                            Icon(
                                              Icons.push_pin,
                                              size: AppSize.s16,
                                              color: AppColors.grey
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
                : const CustomEmptyWidget(title: AppStrings.noUserFound,icon: AppIcons.userNotFoundIcon),
                Visibility(
                  visible: !dashboardScreenState.isLoading,
                  child: Positioned(
                    bottom: 16.0,
                    right: 16.0,
                    child: FloatingActionButton.extended(
                      onPressed: dashboardScreenState.addUserDialog,
                      backgroundColor: AppColors.primaryColor,
                      label: CustomText(title: localizations.addUser, textStyle: getMediumStyle(fontSize: AppSize.s16, color: AppColors.white)),
                      icon: const Icon(Icons.add, color: AppColors.white),
                    ),
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