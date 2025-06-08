import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/constants/app_color.dart';
import 'package:my_wallet/constants/app_strings.dart';
import 'package:my_wallet/constants/app_style.dart';
import 'package:my_wallet/features/transaction/application/bloc/transaction_bloc.dart';
import 'package:my_wallet/features/transaction/application/transaction_details_dialog.dart';
import 'package:my_wallet/l10n/app_localizations.dart';
import 'package:my_wallet/utils/app_extension_method.dart';
import 'package:my_wallet/widgets/custom_text.dart';
import '../../../constants/app_size.dart';
import '../../../utils/helper.dart';
import '../../../widgets/custom_verticle_divider.dart';
import '../domain/transaction_details_model.dart';

class TransactionSubDetailsScreen extends StatefulWidget {

  final TransactionBloc transactionBloc;
  final String transactionId;
  final String title;
  final Widget? closeButton;

  const TransactionSubDetailsScreen({
    super.key,
    required this.transactionBloc,
    required this.transactionId,
    required this.title,
    this.closeButton
  });

  @override
  State createState() => _TransactionSubDetailsScreenState();
}

class _TransactionSubDetailsScreenState extends State<TransactionSubDetailsScreen> {

  AppLocalizations? _localizations;
  List<TransactionDetailsModel> transactionDetailsList = [];
  bool isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.transactionBloc.add(TransactionDetailsEvent(transactionId: widget.transactionId));
    });
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.transactionBloc,
      child: BlocConsumer<TransactionBloc, TransactionState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true, 
              leading: widget.closeButton ?? const Center(child: Tooltip(message: AppStrings.back ,child: BackButton())),
              backgroundColor: AppColors.primaryColor,
              title: CustomText(
                title: widget.title, 
                // title: _localizations!.profile, 
                textStyle: getBoldStyle(color: AppColors.white)
              ),
              iconTheme: const IconThemeData(color: AppColors.white),
              actions: [
                IconButton(
                  onPressed: () => _showTransactionDetailsDialog(), 
                  icon: Icon(Icons.add)
                ),
              ],
            ),
            body: isLoading
            ? Center(child: CircularProgressIndicator.adaptive())
            : transactionDetailsList.isEmpty
              ? Center(child: CustomText(title: 'No details found'))
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
                          child: CustomText(
                            title: 'Description', 
                            textStyle: getSemiBoldStyle(
                              color: Helper.isDark 
                              ? AppColors.white.withValues(alpha: 0.9) 
                              : AppColors.black,
                              fontSize: AppSize.s14
                            ),
                            overflow: TextOverflow.ellipsis,
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
                            title: 'Rate', 
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
                            title: 'Quantity', 
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
                            title: 'Total', 
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
                    itemBuilder: (context, index) {
                      if (index == transactionDetailsList.length) {
                        return const Divider(
                          color: AppColors.grey, 
                          thickness: AppSize.s05, 
                          height: AppSize.s05
                        );
                      } else {
                        final data = transactionDetailsList[index];
                        return Container(
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
                                  child: CustomText(
                                    title: data.description, 
                                    textColor: Helper.isDark 
                                    ? AppColors.white.withValues(alpha: 0.9) 
                                    : AppColors.black,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                )
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
                                    title: data.rate.toStringAsFixed(1), 
                                    textColor: Helper.isDark 
                                    ? AppColors.white.withValues(alpha: 0.9) 
                                    : AppColors.black,
                                    textAlign: TextAlign.center,
                                  )
                                )
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
                                    title: data.quantity.toString(), 
                                    textColor: Helper.isDark 
                                    ? AppColors.white.withValues(alpha: 0.9) 
                                    : AppColors.black,
                                    textAlign: TextAlign.center,
                                  )
                                )
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
                                    title: data.total.toStringAsFixed(1), 
                                    textColor: Helper.isDark 
                                    ? AppColors.white.withValues(alpha: 0.9) 
                                    : AppColors.black,
                                    textAlign: TextAlign.center,
                                  )
                                )
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
                          title: 'Total', 
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
          );
        },
        listener: (context, state) {
          switch (state) {
            case TransactionDetailsLoadingState _:
              isLoading = true;
              break;
            case TransactionFetchDetailsState _:
              isLoading = false;
              transactionDetailsList.clear();
              transactionDetailsList.addAll(state.transactionDetailsList);
              break;
            default:
          }
        }
      ),
    );
  }

  void _showTransactionDetailsDialog({TransactionDetailsModel? transactionModel}) {
    showGeneralDialog(
      context: context, 
      barrierDismissible: true,
      barrierLabel: AppStrings.close,
      pageBuilder: (_, a1, _) => ScaleTransition(
        scale: Tween<double>( begin: 0.8, end: 1.0 ).animate(a1),
        child: TransactionDetailsDialog(
          onAdd: (String description, String rate, String quantity) {
            if(description.isNotEmpty && rate.isNotEmpty && quantity.isNotEmpty) {
              context.pop();
              widget.transactionBloc.add(TransactionAddDetailsEvent(
                transactionId: widget.transactionId,
                description: description,
                rate: double.parse(rate),
                quantity: int.parse(quantity),
                total: double.parse(rate) * int.parse(quantity)
              ));
            }
          },
        ),
      ),
    );
  }

}