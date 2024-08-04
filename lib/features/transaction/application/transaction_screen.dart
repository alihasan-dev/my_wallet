import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_verticle_divider.dart';

class TransactionScreen extends StatefulWidget {
  final UserModel userModel;

  const TransactionScreen({
    super.key,
    required this.userModel
  });

  @override
  State createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {

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
  Color textColor = Helper.isDark ? AppColors.white.withOpacity(0.9) : AppColors.black;
  bool isLoading = true;
  late DateFormat dateFormat;
  AppLocalizations? _localizations;

  @override
  void initState() {
    dateFormat = DateFormat.yMMMd();
    appBarSize = appBarHeight;
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var data = widget.userModel;
    email = data.email;
    name = data.name;
    friendId = data.userId;
    _localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context){
    return BlocConsumer<TransactionBloc, TransactionState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case AllTransactionState:
            state = state as AllTransactionState;
            transactionDataList.clear();
            transactionDataList.addAll(state.listTransaction);
            break;
          case TransactionScrollState:
            state = state as TransactionScrollState;
            appBarSize = state.appbarSize;
            if(appBarSize == appBarHeight){
              headerColor = Helper.isDark ? AppColors.backgroundColorDark : AppColors.white;
              textColor = Helper.isDark ? AppColors.white.withOpacity(0.9) : AppColors.black;
            } else {
              headerColor = AppColors.primaryColor;
              textColor = Helper.isDark ? AppColors.white.withOpacity(0.9) : AppColors.white;
            }
            break;
          default:
        }
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
                duration: const Duration(milliseconds: 300),
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: AppSize.s15,
                      offset: Offset(0.0, 1.0)
                  )
                ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(AppIcons.backArrowIcon, color: AppColors.white),
                    ),
                    CustomText(
                      title: name, 
                      textStyle: getBoldStyle(color: AppColors.white)
                    ),
                    IconButton(
                      onPressed: () => showAddUserSheet(bloc: context.read<TransactionBloc>()),
                      icon: const Icon(AppIcons.addIcon, color: AppColors.white)
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
                            width: AppSize.s05, 
                            color: AppColors.white.withOpacity(0.8)
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppSize.s10, vertical: AppSize.s15),
                              //color: AppColor.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    title: _localizations!.date, 
                                    textStyle: getSemiBoldStyle(color: textColor, fontSize: AppSize.s14,)
                                  ),
                                  InkWell(
                                    onTap: () => context.read<TransactionBloc>().add(TransactionDateSortEvent()),
                                    child: Icon(AppIcons.swapIcon, size: AppSize.s18, color: textColor),
                                  ),
                                ],
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
                                  InkWell(
                                    onTap: () => context.read<TransactionBloc>().add(TransactionTypeSortEvent()),
                                    child: Icon(
                                      AppIcons.swapIcon, 
                                      size: AppSize.s18, 
                                      color: textColor
                                    ),
                                  ),
                                ],
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
                                  InkWell(
                                    onTap: () => context.read<TransactionBloc>().add(TransactionAmountSortEvent()),
                                    child: Icon(
                                      AppIcons.swapIcon, 
                                      size: AppSize.s18, 
                                      color: textColor
                                    ),
                                  ),
                                ],
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
                          if(_scrollController.position.userScrollDirection != ScrollDirection.idle){
                            if(_scrollController.position.userScrollDirection == ScrollDirection.forward && appBarSize != appBarHeight){
                              context.read<TransactionBloc>().add(TransactionScrollEvent(appbarSize: appBarHeight));
                            } else if(_scrollController.position.userScrollDirection == ScrollDirection.reverse){
                              context.read<TransactionBloc>().add(TransactionScrollEvent(appbarSize: 0.0));
                            }
                          }
                          return true;
                        },
                        child: ListView.separated(
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: transactionDataList.length + 1,
                          itemBuilder: (context, index){
                            if(index == transactionDataList.length){
                              return const Divider(color: AppColors.grey, thickness: AppSize.s05, height: AppSize.s05);
                            } else {
                              var subData = transactionDataList[index];
                              return Container(
                                color: AppColors.grey,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: AppSize.s10, vertical: AppSize.s15),
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
                                        padding: const EdgeInsets.symmetric(horizontal: AppSize.s10, vertical: AppSize.s15),
                                        color: Helper.isDark 
                                        ? AppColors.backgroundColorDark 
                                        : AppColors.white, 
                                        child: CustomText(
                                          title: subData.type == AppStrings.transfer ? _localizations!.transfer : _localizations!.receive, 
                                          textColor: subData.type == AppStrings.transfer 
                                          ? AppColors.red 
                                          : AppColors.green
                                        ),
                                      ),
                                    ),
                                    const CustomVerticalDivider(),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: AppSize.s10, vertical: AppSize.s15),
                                        color: Helper.isDark 
                                        ? AppColors.backgroundColorDark 
                                        : AppColors.white, 
                                        child: CustomText(
                                          title: subData.amount.toString(), 
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
                    const Divider(color: AppColors.grey, thickness: AppSize.s05, height: AppSize.s05),
                    Container(
                      color: AppColors.grey,
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
                                )
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
                                title: transactionDataList.fold(0.0, (temp, item){
                                  return item.type == AppStrings.transfer ? temp - item.amount : temp + item.amount;
                                }).toString(),
                                textStyle: getSemiBoldStyle(
                                  color: Helper.isDark 
                                  ? AppColors.white.withOpacity(0.9) 
                                  : AppColors.black
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      listener: (context, state){
        switch (state.runtimeType) {
          case AllTransactionState:
            isLoading = false;
            break;
          default:
        }
      },
    );
  }

  void showAddUserSheet({required TransactionBloc bloc}){
    errorAmount = false;
    errorDate = false;
    showDialog(
      context: context, 
      builder: (_) => AddTransactionDialog(userName: name, friendId: friendId)
    );
  }
}