import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:text_marquee/text_marquee.dart';
import '../../../features/transaction/application/add_transaction_details_dialog.dart';
import '../../../features/transaction/application/sub_transaction_bloc/sub_transaction_bloc.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_theme.dart';
import '../../../features/dashboard/application/bloc/dashboard_bloc.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_style.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_extension_method.dart';
import '../../../widgets/custom_text.dart';
import '../../../constants/app_size.dart';
import '../../../utils/helper.dart';
import '../../../widgets/custom_verticle_divider.dart';
import '../domain/transaction_details_model.dart';

class TransactionSubDetailsScreen extends StatefulWidget {

  final String transactionId;
  final String title;
  final Widget? closeButton;

  const TransactionSubDetailsScreen({
    super.key,
    required this.transactionId,
    required this.title,
    this.closeButton
  });

  @override
  State createState() => _TransactionSubDetailsScreenState();
}

class _TransactionSubDetailsScreenState extends State<TransactionSubDetailsScreen> with Helper {

  AppLocalizations? _localizations;
  List<TransactionDetailsModel> transactionDetailsList = [];
  bool isLoading = false;
  late SubTransactionBloc subTransactionBloc;

  @override
  void initState() {
    subTransactionBloc = context.read<SubTransactionBloc>();
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubTransactionBloc, SubTransactionState>(
      builder: (context, state) {
        return PopScope(
          onPopInvokedWithResult: (_,_) {
            context.read<DashboardBloc>().add(DashboardTransactionDetailsWindowCloseEvent());
          },
          child: Scaffold(
            backgroundColor: Helper.isDark 
            ? AppColors.backgroundColorDark 
            : AppColors.white,
            appBar: AppBar(
              centerTitle: false,
              elevation: 0, 
              leading: widget.closeButton ?? Center(
                child: Tooltip(
                  message: AppStrings.back,
                  child: BackButton(
                    onPressed: () => context.pop()
                  ),
                ),
              ),
              backgroundColor: AppColors.primaryColor,
              title: CustomText(
                title: widget.title,
                textStyle: getBoldStyle(color: AppColors.white)
              ),
              iconTheme: const IconThemeData(color: AppColors.white),
              actions: [
                AnimatedSize(
                  duration: MyAppTheme.animationDuration,
                  child: transactionDetailsList.any((item) => item.isSelected)
                  ? Row(
                      children: [
                        OutlinedButton(
                          onPressed: () => subTransactionBloc.add(SubTransactionClearSelectionEvent()),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.white,
                            padding: EdgeInsets.symmetric(horizontal: AppSize.s12, vertical: 10),
                            side: BorderSide(color: AppColors.white)
                          ), 
                          child: CustomText(
                            title:'${transactionDetailsList.where((item) => item.isSelected).length}  ${_localizations!.unselect}',
                            textColor: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: AppSize.s6),
                        IconButton(
                          tooltip: _localizations!.delete,
                          onPressed: () => _showDeleteTransactionDialog(context), 
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(AppIcons.deleteIcon, color: AppColors.white)
                        ),
                      ],
                    )
                  : IconButton(
                    tooltip: _localizations!.addTransactionDetails,
                    onPressed: () => _showTransactionDetailsDialog(), 
                    icon: Icon(Icons.add)
                  ),
                ),
              ],
            ),
            body: isLoading
            ? Center(child: CircularProgressIndicator.adaptive())
            : transactionDetailsList.isEmpty
              ? Center(
                  child: Text(
                    _localizations!.noTransactionDetailsFound,
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
                SizedBox(
                  height: AppBar().preferredSize.height,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.s10, 
                            vertical: AppSize.s15,
                          ),
                          color: Helper.isDark 
                          ? AppColors.backgroundColorDark 
                          : AppColors.white, 
                          child: TextMarquee(
                            _localizations!.description,
                            spaceSize: 40,
                            style: getSemiBoldStyle(
                              color: Helper.isDark 
                              ? AppColors.white.withValues(alpha: 0.9) 
                              : AppColors.black,
                              fontSize: AppSize.s14
                            ),
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
                          child: TextMarquee(
                            _localizations!.rate,
                            spaceSize: 40,
                            style: getSemiBoldStyle(
                              color: Helper.isDark 
                              ? AppColors.white.withValues(alpha: 0.9) 
                              : AppColors.black,
                              fontSize: AppSize.s14
                            ),
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
                            title: _localizations!.quantity, 
                            textStyle: getSemiBoldStyle(
                              color: Helper.isDark 
                              ? AppColors.white.withValues(alpha: 0.9) 
                              : AppColors.black,
                              fontSize: AppSize.s14
                            ),
                            textAlign: TextAlign.center,
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
                            title: _localizations!.total, 
                            textStyle: getSemiBoldStyle(
                              color: Helper.isDark 
                              ? AppColors.white.withValues(alpha: 0.9) 
                              : AppColors.black,
                              fontSize: AppSize.s14
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.grey, thickness: AppSize.s05, height: AppSize.s05),
                Expanded(
                  child: ListView.separated(
                    itemCount: transactionDetailsList.length + 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index == transactionDetailsList.length) {
                        return const Divider(
                          color: AppColors.grey, 
                          thickness: AppSize.s05, 
                          height: AppSize.s05
                        );
                      } else {
                        final data = transactionDetailsList[index];
                        return InkWell(
                          onTap: () => subTransactionBloc.add(SubTransactionSelectDetailsEvent(selectedIndex: index)),
                          child: Container(
                            color: AppColors.grey,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSize.s10, 
                                      vertical: AppSize.s15,
                                    ),
                                    color: Helper.isDark 
                                    ? AppColors.backgroundColorDark 
                                    : AppColors.white, 
                                    child: Row(
                                      children: [
                                        AnimatedSize(
                                          duration: MyAppTheme.animationDuration,
                                          child: data.isSelected
                                          ? const Row(
                                              children: [
                                                Icon(
                                                  AppIcons.checkCircleOutlineIcon, 
                                                  size: AppSize.s18, 
                                                  color: AppColors.green
                                                ),
                                                SizedBox(width: AppSize.s5),
                                              ],
                                            )
                                          : const SizedBox.shrink()
                                        ),
                                        Expanded(
                                          child: TextMarquee(
                                            data.description,
                                            spaceSize: 40,
                                            style: TextStyle(
                                              color: Helper.isDark 
                                              ? AppColors.white.withValues(alpha: 0.9) 
                                              : AppColors.black,
                                              fontSize: 14
                                            ),
                                          ),
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
                                      vertical: AppSize.s15,
                                    ),
                                    color: Helper.isDark 
                                    ? AppColors.backgroundColorDark 
                                    : AppColors.white, 
                                    child: CustomText(
                                      title: data.rate.toString().currencyFormat, 
                                      textColor: Helper.isDark 
                                      ? AppColors.white.withValues(alpha: 0.9) 
                                      : AppColors.black,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                const CustomVerticalDivider(),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSize.s10, 
                                      vertical: AppSize.s15,
                                    ),
                                    color: Helper.isDark 
                                    ? AppColors.backgroundColorDark 
                                    : AppColors.white, 
                                    child: CustomText(
                                      title: data.quantity.toStringAsFixed(0), 
                                      textColor: Helper.isDark 
                                      ? AppColors.white.withValues(alpha: 0.9) 
                                      : AppColors.black,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                const CustomVerticalDivider(),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSize.s10, 
                                      vertical: AppSize.s15,
                                    ),
                                    color: Helper.isDark 
                                    ? AppColors.backgroundColorDark 
                                    : AppColors.white, 
                                    child: CustomText(
                                      title: data.total.toString().currencyFormat, 
                                      textColor: Helper.isDark 
                                      ? AppColors.white.withValues(alpha: 0.9) 
                                      : AppColors.black,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
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
                    )
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Offstage(
              offstage: transactionDetailsList.isEmpty,
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
                          title: _localizations!.total, 
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
                          title: (transactionDetailsList.fold(0.0, (p1, p2) => p1 + p2.total)).balanceFormat,
                          textStyle: getSemiBoldStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ),
        );
      },
      listener: (context, state) {
        switch (state) {
          case SubTransactionDetailsLoadingState _:
            isLoading = true;
            break;
          case SubTransactionFetchDetailsState _:
            isLoading = false;
            transactionDetailsList.clear();
            transactionDetailsList.addAll(state.transactionDetailsList);
            break;
          default:
        }
      }
    );
  }

  Future<void> _showDeleteTransactionDialog(BuildContext context) async {
    if(await confirmationDialog(context: context, title: _localizations!.deleteSubTransaction, content: _localizations!.deleteSubTransactionMsg, localizations: _localizations!)) {
      subTransactionBloc.add(SubTransactionDeleteEvent());
    }
  }

  void _showTransactionDetailsDialog() {
    showGeneralDialog(
      context: context, 
      barrierDismissible: true,
      barrierLabel: AppStrings.close,
      pageBuilder: (_, a1, _) => ScaleTransition(
        scale: Tween<double>( begin: 0.8, end: 1.0 ).animate(a1),
        child: AddTransactionDetailsDialog(
          transactionBloc: subTransactionBloc,
          transactionId: widget.transactionId,
        ),
      ),
    );
  }

}