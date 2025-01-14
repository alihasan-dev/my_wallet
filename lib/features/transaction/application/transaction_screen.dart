import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/app_theme.dart';
import '../../../features/transaction/application/transaction_details.dart';
import '../../../features/transaction/application/transaction_filter_dialog.dart';
import '../../../utils/app_extension_method.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_style.dart';
import '../../../constants/app_size.dart';
import '../../../features/dashboard/domain/user_model.dart';
import '../../../features/transaction/application/add_transaction_dialog.dart';
import '../../../features/transaction/application/bloc/transaction_bloc.dart';
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
  String profileImg = AppStrings.emptyString;
  String friendId = AppStrings.emptyString;
  bool errorAmount = false;
  bool errorDate = false;
  var transactionDataList = <TransactionModel>[];
  late ScrollController _scrollController;
  double appBarHeight = AppBar().preferredSize.height;
  double appBarSize = 0.0;
  Color headerColor = Helper.isDark ? AppColors.backgroundColorDark : AppColors.white;
  double animatedBorderSide = 0.0;
  Color textColor = Helper.isDark ? AppColors.white.withValues(alpha: 0.9) : AppColors.black;
  bool isLoading = true;
  double availableBalance = 0.0;
  late DateFormat dateFormat;
  AppLocalizations? _localizations;
  late TransactionBloc _transactionBloc;
  bool isFilterEnable = false;
  RangeValues? amountChangeValue;
  DateTimeRange? initialDateTimeRage;
  String transactionType = AppStrings.all;
  double maxAmount = - double.maxFinite;
  double minAmount = double.maxFinite;

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
      profileImg = data.profileImg;
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
                          Tooltip(
                            message: _localizations!.back,
                            child: Material(
                              color: AppColors.transparent,
                              child: InkWell(
                                onTap: () => context.pop(),
                                borderRadius: BorderRadius.circular(30),
                                child: Ink(
                                  child: Row(
                                    children: [
                                      Icon(
                                        !kIsWeb && (Platform.isIOS || Platform.isMacOS)
                                        ? AppIcons.backArrowIconIOS
                                        : AppIcons.backArrowIcon, 
                                        color: AppColors.white,
                                        size: AppSize.s22,
                                      ),
                                      Hero(
                                        tag: 'profile',
                                        child: CustomImageWidget(
                                          imageUrl: profileImg, 
                                          imageSize: AppSize.s40,
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
                    AnimatedSize(
                      duration: MyAppTheme.animationDuration,
                      child: transactionDataList.any((item) => item.selected)
                      ? Row(
                          children: [
                            IconButton(
                              tooltip: _localizations!.delete,
                              onPressed: () => _transactionBloc.add(TransactionDeleteEvent()), 
                              icon: const Icon(Icons.delete_outline, color: AppColors.white)
                            ),
                            // Need to implement later
                            // AnimatedSize(
                            //   duration: MyAppTheme.animationDuration,
                            //   child: transactionDataList.where((item) => item.selected).length > 1
                            //   ? const SizedBox()
                            //   : IconButton(
                            //     onPressed: () => debugPrint(''), 
                            //     icon: const Icon(Icons.edit_outlined, color: AppColors.white)
                            //   ),
                            // ),
                          ],
                        )
                      : Row(
                        children: [
                          IconButton(
                            tooltip: _localizations!.addTransaction,
                            onPressed: () => showAddUserSheet(),
                            icon: const Icon(
                              AppIcons.addIcon, 
                              color: AppColors.white, 
                              size: AppSize.s26
                            ),
                          ),
                          Badge(
                            backgroundColor: AppColors.red,
                            isLabelVisible: isFilterEnable,
                            alignment: const Alignment(0.4,- 0.5),
                            smallSize: AppSize.s10,
                            child: IconButton(
                              tooltip: _localizations!.advanceFilter,
                              onPressed: () => _transactionBloc.add(TransactionFilterEvent()),
                              icon: const Icon(
                                Icons.filter_alt,
                                color: AppColors.white
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: _localizations!.exportReport,
                            onPressed: () => _transactionBloc.add(TransactionExportPDFEvent()),
                            icon: const Icon(
                              AppIcons.downloadIcon,
                              color: AppColors.white
                            ),
                          ),
                        ],
                      )
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isLoading
                ? const Center(child: CircularProgressIndicator.adaptive()) 
                : transactionDataList.isEmpty
                ? Center(
                  child: Text(
                    _localizations!.noTransactionFound,
                    style: TextStyle(
                      color: Helper.isDark 
                      ? AppColors.white.withValues(alpha: 0.9) 
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
                      height: appBarHeight,
                      decoration: BoxDecoration(
                        color: headerColor,
                        border: Border(
                          top: kIsWeb
                          ? BorderSide.none
                          : BorderSide(
                            width: animatedBorderSide, 
                            color: AppColors.white.withValues(alpha: 0.8)
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
                              color: textColor.withValues(alpha: 0.8)
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
                              color: textColor.withValues(alpha: 0.8)
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
                            if(index == transactionDataList.length) {
                              return const Divider(
                                color: AppColors.grey, 
                                thickness: AppSize.s05, 
                                height: AppSize.s05
                              );
                            } else {
                              var subData = transactionDataList[index];
                              return InkWell(
                                onTap: () => _transactionBloc.add(TransactionSelectListItemEvent(index: index)),
                                child: Container(
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
                                          child: Row(
                                            children: [
                                              AnimatedSize(
                                                duration: MyAppTheme.animationDuration,
                                                child: subData.selected
                                                ? const Row(
                                                    children: [
                                                      Icon(
                                                        Icons.check_circle_outline, 
                                                        size: AppSize.s18, 
                                                        color: AppColors.green
                                                      ),
                                                      SizedBox(width: AppSize.s5),
                                                    ],
                                                  )
                                                : const SizedBox.shrink()
                                              ),
                                              CustomText(
                                                title: dateFormat.format(subData.date), 
                                                textColor: Helper.isDark 
                                                ? AppColors.white.withValues(alpha: 0.9) 
                                                : AppColors.black
                                              ),
                                            ],
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
                                            ? AppColors.white.withValues(alpha: 0.9) 
                                            : AppColors.black
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
            offstage: transactionDataList.isEmpty,
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
                    color: AppColors.grey.withValues(alpha: 0.5), 
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
                          ? AppColors.white.withValues(alpha: 0.9) 
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
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        switch (state) {
          case AllTransactionState _:
            isLoading = false;
            if(state.isTransactionAgainstFilter && initialDateTimeRage != null && (amountChangeValue != null || (maxAmount != - double.maxFinite.toInt()))) {
              RangeValues? tempAmountChangeValue;
              if(amountChangeValue == null) {
                tempAmountChangeValue = RangeValues(minAmount.toDouble(), maxAmount.toDouble());
              } else {
                tempAmountChangeValue = RangeValues(amountChangeValue!.start, amountChangeValue!.end);
              }
              _transactionBloc.add(TransactionApplyFilterEvent(
                dateTimeRange: initialDateTimeRage,
                transactionType: transactionType,
                amountRangeValues: tempAmountChangeValue
              ));
            }
            if(!state.isTransactionAgainstFilter) {
              availableBalance = state.totalBalance;
              isFilterEnable = state.isFilterEnable;
              transactionDataList.clear();
              transactionDataList.addAll(state.listTransaction);
              if(!isFilterEnable) {
                transactionType = AppStrings.all;
                initialDateTimeRage = null;
                amountChangeValue = null;
              }
            }
            break;
          case TransactionScrollState _:
            appBarSize = state.appbarSize;
            if(appBarSize == appBarHeight) {
              animatedBorderSide = AppSize.s0;
              headerColor = Helper.isDark 
              ? AppColors.backgroundColorDark 
              : AppColors.white;
              textColor = Helper.isDark 
              ? AppColors.white.withValues(alpha: 0.9) 
              : AppColors.black;
            } else {
              animatedBorderSide = AppSize.s05;
              headerColor = AppColors.primaryColor;
              textColor = Helper.isDark 
              ? AppColors.white.withValues(alpha: 0.9) 
              : AppColors.white;
            }
            break;
          case TransactionProfileUpdateState _:
            name = state.userName;
            profileImg = state.profileImage;
            break;
          case TransactionFilterState _:
            showFilterDialog();
            break;
          case TransactionLoadingState _:
            showLoadingDialog(context: context);
            break;
          case TransactionExportPDFState _:
            hideLoadingDialog(context: context);
            if(state.isSuccess && !kIsWeb) {
              showSnackBar(context: context, title: state.message, color: AppColors.green);
            } 
            if(!state.isSuccess) {
              showSnackBar(context: context, title: state.message);
            }
            break;
           case TransactionChangeAmountRangeState _:
              amountChangeValue = state.rangeAmount;
              break;
            case TransactionTypeChangeState _:
              transactionType = state.type;
              break;
          default:
        }
      },
    );
  }

  void showAddUserSheet() {
    errorAmount = false;
    errorDate = false;
    showGeneralDialog(
      context: context, 
      barrierDismissible: true,
      barrierLabel: AppStrings.close,
      pageBuilder: (_, a1, __) => ScaleTransition(
        scale: Tween<double>( begin: 0.5, end: 1.0 ).animate(a1),
        child: AddTransactionDialog(userName: name, friendId: friendId),
      )
    );
  }

  Future<void> showFilterDialog() async {
    if(maxAmount == - double.maxFinite) {
      for(var item in transactionDataList) {
        if(maxAmount < item.amount) {
          maxAmount = item.amount;
        }
        if(minAmount > item.amount) {
          minAmount = item.amount;
        }
      }
    } 
    if(maxAmount != - double.maxFinite) {
      for(var item in transactionDataList) {
        if(item.amount > maxAmount) {
          maxAmount = item.amount;
        }
      }
      var data = await showGeneralDialog<Map>(
        context: context,
        barrierDismissible: true,
        barrierLabel: AppStrings.close,
        pageBuilder: (_, a1, __) => ScaleTransition(
          scale: Tween<double>( begin: 0.5, end: 1.0 ).animate(a1),
          child: TransactionFilterDialog(
            amountChangeValue: amountChangeValue,
            finalAmountRange: RangeValues(minAmount, maxAmount),
            transactionBloc: _transactionBloc,
            initialDateTimeRage: initialDateTimeRage,
            transactionType: transactionType
          ),
        ),
      );
      if(data != null) {
        if(data.isEmpty) {
          _transactionBloc.add(TransactionClearFilterEvent(clearFilter: isFilterEnable));
        } else {
          initialDateTimeRage = data['initial_date_time_range'];
          _transactionBloc.add(TransactionApplyFilterEvent(
            dateTimeRange: data['initial_date_time_range'],
            transactionType: data['transaction_type'],
            amountRangeValues: data['amount_range']
          ));
        }
      }
    }
  }

}