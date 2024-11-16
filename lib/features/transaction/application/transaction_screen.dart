import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_wallet/constants/app_theme.dart';
import 'package:my_wallet/features/transaction/application/transaction_details.dart';
import '../../../utils/app_extension_method.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_style.dart';
import '../../../constants/app_size.dart';
import '../../../features/dashboard/domain/user_model.dart';
import '../../../features/transaction/application/add_transaction_dialog.dart';
import '../../../features/transaction/application/bloc/transaction_bloc.dart';
import '../../../features/transaction/application/bloc/transaction_event.dart';
import '../../../features/transaction/application/bloc/transaction_state.dart';
import '../../../features/transaction/domain/transaction_model.dart';
import '../../../utils/helper.dart';
import '../../../widgets/custom_image_widget.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_verticle_divider.dart';

class TransactionScreen extends StatefulWidget {
  final UserModel? userModel;
  final TransactionDetailsState transactionDetailsState;
  const TransactionScreen({
    super.key,
    required this.userModel,
    required this.transactionDetailsState
  });

  @override
  State createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> with Helper {

  String email = AppStrings.emptyString;
  String name = AppStrings.emptyString;
  String friendId = AppStrings.emptyString;
  bool errorAmount = false;
  bool errorDate = false;
  var transactionDataList = <TransactionModel>[];
  late ScrollController _scrollController;
  double appBarHeight = AppBar().preferredSize.height;
  double appBarSize = 0.0;
  Color headerColor = Helper.isDark ? AppColors.backgroundColorDark : AppColors.white;
  double animatedBorderSide = 0.0;
  Color textColor = Helper.isDark ? AppColors.white.withOpacity(0.9) : AppColors.black;
  bool isLoading = true;
  double availableBalance = 0.0;
  late DateFormat dateFormat;
  AppLocalizations? _localizations;
  late TransactionBloc _transactionBloc;

  @override
  void initState() {
    _transactionBloc = context.read<TransactionBloc>();
    dateFormat = DateFormat.yMMMd();
    appBarSize = appBarHeight;
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(widget.userModel != null) {
      var data = widget.userModel;
      email = data!.email;
      name = data.name;
      friendId = data.userId;
    }
    _localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  } 

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 0, 
            shadowColor: AppColors.transparent, 
            backgroundColor: AppColors.primaryColor
          ),
          backgroundColor: Helper.isDark 
          ? AppColors.backgroundColorDark 
          : AppColors.white,
          body: Column(
            children: [
              AnimatedContainer(
                height: appBarSize,
                duration: const Duration(milliseconds: 450),
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: AppSize.s15,
                      offset: Offset(0.0, 1.0)
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: AppSize.s10),
                          Material(
                            color: AppColors.transparent,
                            child: InkWell(
                              onTap: () => context.pop(),
                              borderRadius: BorderRadius.circular(30),
                              child: Ink(
                                child: Row(
                                  children: [
                                    Icon(
                                      !kIsWeb && Platform.isIOS
                                      ? AppIcons.backArrowIconIOS
                                      : AppIcons.backArrowIcon, 
                                      color: AppColors.white,
                                      size: 22,
                                    ),
                                    Hero(
                                      tag: 'profile',
                                      child: CustomImageWidget(
                                        imageUrl: widget.userModel == null
                                        ? ''
                                        : widget.userModel!.profileImg, 
                                        imageSize: AppSize.s18,
                                        circularPadding: AppSize.s5,
                                        strokeWidth: AppSize.s1,
                                        padding: 1.2,
                                        borderWidth: 0,
                                        fromProfile: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSize.s6),
                          Expanded(
                            child: Material(
                              color: AppColors.transparent,
                              child: InkWell(
                                onTap: () => MyAppTheme.isThreeColumnMode(context)
                                ? widget.transactionDetailsState.toggleDisplayProfileColumn()
                                : context.go('/dashboard/${widget.userModel!.userId}/profile', extra: widget.userModel),
                                child: SizedBox(
                                  height: double.maxFinite,
                                  child: Row(
                                    children: [
                                      CustomText(
                                        title: name, 
                                        textStyle: getBoldStyle(color: AppColors.white)
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => showAddUserSheet(),
                          icon: const Icon(
                            AppIcons.addIcon, 
                            color: AppColors.white, 
                            size: AppSize.s26
                          ),
                        ),
                        Offstage(
                          offstage: availableBalance == 0.0 ? true : false,
                          child: IconButton(
                            onPressed: () => _transactionBloc.add(TransactionExportPDFEvent()),
                            icon: const Icon(
                              AppIcons.downloadIcon, 
                              color: AppColors.white
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor)) 
                : transactionDataList.isEmpty
                ? Center(
                  child: Text(
                    _localizations!.noTransactionFound,
                    style: TextStyle(
                      color: Helper.isDark 
                      ? AppColors.white.withOpacity(0.9) 
                      : AppColors.black, 
                      fontSize: AppSize.s18, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
                : Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: headerColor,
                        border: Border(
                          top: BorderSide(
                            width: animatedBorderSide, 
                            color: AppColors.white.withOpacity(0.8)
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Material(
                              color: AppColors.transparent,
                              child: InkWell(
                                onTap: () => _transactionBloc.add(TransactionDateSortEvent()),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.s10, 
                                    vertical: AppSize.s15
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        title: _localizations!.date, 
                                        textStyle: getSemiBoldStyle(
                                          color: textColor, 
                                          fontSize: AppSize.s14
                                        ),
                                      ),
                                      Icon(
                                        AppIcons.swapIcon, 
                                        size: AppSize.s18, 
                                        color: textColor
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: appBarHeight - AppSize.s8,
                            child: VerticalDivider(
                              thickness: AppSize.s05, 
                              width: AppSize.s05, 
                              color: textColor.withOpacity(0.8)
                            ),
                          ),
                          Expanded(
                            child: Material(
                              color: AppColors.transparent,
                              child: InkWell(
                                onTap: () => _transactionBloc.add(TransactionTypeSortEvent()),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.s10, 
                                    vertical: AppSize.s15
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        title: _localizations!.type, 
                                        textStyle: getSemiBoldStyle(color: textColor, fontSize: AppSize.s14)
                                      ),
                                      Icon(
                                        AppIcons.swapIcon, 
                                        size: AppSize.s18, 
                                        color: textColor
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: appBarHeight - AppSize.s8,
                            child: VerticalDivider(
                              thickness: AppSize.s05, 
                              width: AppSize.s05, 
                              color: textColor.withOpacity(0.8)
                            ),
                          ),
                          Expanded(
                            child: Material(
                              color: AppColors.transparent,
                              child: InkWell(
                                onTap: () => _transactionBloc.add(TransactionAmountSortEvent()),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.s10, 
                                    vertical: AppSize.s15
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        title: _localizations!.amount, 
                                        textStyle: getSemiBoldStyle(color: textColor, fontSize: AppSize.s14)
                                      ),
                                      Icon(
                                        AppIcons.swapIcon, 
                                        size: AppSize.s18, 
                                        color: textColor
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: AppColors.grey, thickness: AppSize.s05, height: AppSize.s05),
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if(_scrollController.position.userScrollDirection != ScrollDirection.idle) {
                            if(_scrollController.position.userScrollDirection == ScrollDirection.forward && appBarSize != appBarHeight) {
                              _transactionBloc.add(TransactionScrollEvent(appbarSize: appBarHeight));
                            } else if(_scrollController.position.userScrollDirection == ScrollDirection.reverse && _scrollController.offset > 180.0) {
                              _transactionBloc.add(TransactionScrollEvent(appbarSize: 0.0));
                            }
                          }
                          return true;
                        },
                        child: ListView.separated(
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: transactionDataList.length + 1,
                          itemBuilder: (context, index) {
                            if(index == transactionDataList.length){
                              return const Divider(
                                color: AppColors.grey, 
                                thickness: AppSize.s05, 
                                height: AppSize.s05
                              );
                            } else {
                              var subData = transactionDataList[index];
                              return Container(
                                color: AppColors.grey,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSize.s10, 
                                          vertical: AppSize.s15
                                        ),
                                        color: Helper.isDark 
                                        ? AppColors.backgroundColorDark
                                        : AppColors.white, 
                                        child: CustomText(
                                          title: dateFormat.format(subData.date), 
                                          textColor: Helper.isDark 
                                          ? AppColors.white.withOpacity(0.9) 
                                          : AppColors.black
                                        ),
                                      ),
                                    ),
                                    const CustomVerticalDivider(),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSize.s10, 
                                          vertical: AppSize.s15
                                        ),
                                        color: Helper.isDark 
                                        ? AppColors.backgroundColorDark 
                                        : AppColors.white, 
                                        child: CustomText(
                                          title: subData.type == AppStrings.transfer 
                                          ? _localizations!.transfer 
                                          : _localizations!.receive, 
                                          textColor: subData.type == AppStrings.transfer 
                                          ? AppColors.red 
                                          : AppColors.green
                                        ),
                                      ),
                                    ),
                                    const CustomVerticalDivider(),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSize.s10, 
                                          vertical: AppSize.s15
                                        ),
                                        color: Helper.isDark 
                                        ? AppColors.backgroundColorDark 
                                        : AppColors.white, 
                                        child: CustomText(
                                          title: subData.amount.toString().currencyFormat, 
                                          textColor: Helper.isDark 
                                          ? AppColors.white.withOpacity(0.9) 
                                          : AppColors.black
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          separatorBuilder: (context, index) => const Divider(
                            color: AppColors.grey, 
                            thickness: AppSize.s05, 
                            height: AppSize.s05
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Offstage(
            offstage: availableBalance == 0.0 ? true : false,
            child: Container(
              padding: EdgeInsets.only(
                left: AppSize.s15,
                right: AppSize.s15,
                bottom: !kIsWeb && Platform.isIOS ? AppSize.s18 : AppSize.s4,
              ),
              decoration: BoxDecoration(
                color: Helper.isDark 
                ? AppColors.backgroundColorDark 
                : AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey.withOpacity(0.5), 
                    blurRadius: AppSize.s2, 
                    offset: const Offset(0, -0.5)
                  ),
                ]
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.s10, 
                        vertical: AppSize.s15
                      ),
                      color: Helper.isDark 
                      ? AppColors.backgroundColorDark 
                      : AppColors.white, 
                      child: CustomText(
                        title: _localizations!.availableBalance, 
                        textStyle: getSemiBoldStyle(
                          color: Helper.isDark 
                          ? AppColors.white.withOpacity(0.9) 
                          : AppColors.black
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.s10, 
                        vertical: AppSize.s15
                      ),
                      color: Helper.isDark 
                      ? AppColors.backgroundColorDark
                      : AppColors.white, 
                      child: CustomText(
                        title: availableBalance.balanceFormat,
                        textStyle: getSemiBoldStyle(
                          color: availableBalance.isNegative
                          ? AppColors.red
                          : AppColors.green
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
        );
      },
      listener: (context, state) {
        switch (state) {
          case AllTransactionState _:
            isLoading = false;
            availableBalance = state.totalBalance;
            transactionDataList.clear();
            transactionDataList.addAll(state.listTransaction);
            break;
          case TransactionScrollState _:
            appBarSize = state.appbarSize;
            if(appBarSize == appBarHeight) {
              animatedBorderSide = AppSize.s0;
              headerColor = Helper.isDark 
              ? AppColors.backgroundColorDark 
              : AppColors.white;
              textColor = Helper.isDark 
              ? AppColors.white.withOpacity(0.9) 
              : AppColors.black;
            } else {
              animatedBorderSide = AppSize.s05;
              headerColor = AppColors.primaryColor;
              textColor = Helper.isDark 
              ? AppColors.white.withOpacity(0.9) 
              : AppColors.white;
            }
            break;
          case TransactionLoadingState _:
            showLoadingDialog(context: context);
            break;
          case TransactionExportPDFState _:
            hideLoadingDialog(context: context);
            if(state.isSuccess) {
              showSnackBar(context: context, title: state.message, color: AppColors.green);
            } else {
              showSnackBar(context: context, title: state.message);
            }
            break;
          default:
        }
      },
    );
  }

  void showAddUserSheet() {
    errorAmount = false;
    errorDate = false;
    showDialog(
      context: context, 
      builder: (_) => AddTransactionDialog(userName: name, friendId: friendId)
    );
  }

}