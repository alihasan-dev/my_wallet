import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/transaction/application/sub_transaction_bloc/sub_transaction_bloc.dart';
import '../../../features/transaction/application/transaction_sub_details_screen.dart';
import '../../../l10n/app_localizations.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_theme.dart';
import '../../../features/dashboard/application/bloc/dashboard_bloc.dart';
import '../../../features/dashboard/domain/user_model.dart';
import '../../../features/profile/application/profile_screen.dart';
import '../../../features/transaction/application/transaction_screen.dart';
import 'bloc/transaction_bloc.dart';

class TransactionDetails extends StatefulWidget {
  final DashboardBloc dashboardBloc;
  final UserModel userModel;

  const TransactionDetails({
    required this.dashboardBloc,
    required this.userModel,
    super.key
  });

  @override
  State createState() => TransactionDetailsState();
}

class TransactionDetailsState extends State<TransactionDetails> {

  late final ValueNotifier<bool> _displayProfileColumn;
  late final ValueNotifier<bool> _displayTransactionDetailsColumn;
  String transactionId = '';
  String title = '';

  @override
  void initState() {
    _displayProfileColumn = ValueNotifier(false);
    _displayTransactionDetailsColumn = ValueNotifier(false);
    super.initState();
  }

  void toggleDisplayProfileColumn() {
    if(_displayTransactionDetailsColumn.value) {
      _displayTransactionDetailsColumn.value = false;
    }
    _displayProfileColumn.value = !_displayProfileColumn.value;
  } 

  void toggleTransactionDetailsColumn({String? transactionId, String? title}) {
    if (_displayTransactionDetailsColumn.value && title == null) {
      _displayTransactionDetailsColumn.value = false;
    } else {
      _displayTransactionDetailsColumn.value = true;
    }
    if(_displayProfileColumn.value) {
      _displayProfileColumn.value = false;
    }
    this.transactionId = transactionId ?? '';
    this.title = title ?? '';
    setState(() {});
  } 

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: BlocProvider(
            create: (_) => TransactionBloc(
              userName: widget.userModel.name, 
              friendId: widget.userModel.userId,
              dashboardBloc: widget.dashboardBloc
            ), 
            child: TransactionScreen(userModel: widget.userModel, transactionDetailsState: this)
          ),
        ),
        AnimatedSize(
          duration: MyAppTheme.animationDuration,
          child: ValueListenableBuilder(
            valueListenable: _displayProfileColumn,
            builder: (context, displayChatDetailsColumn, _) {
              if(!MyAppTheme.isThreeColumnMode(context) || !displayChatDetailsColumn) {
                return const SizedBox(
                  height: double.infinity,
                  width: 0,
                );
              }
              return Container(
                width: MyAppTheme.columnWidth,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                ),
                child: ProfileScreen(
                  userId: widget.userModel.userId,
                  closeButton: IconButton(
                    tooltip: localizations.close,
                    onPressed: toggleDisplayProfileColumn, 
                    icon: const Icon(AppIcons.closeIcon)
                  ),
                ),
              );
            },
          ),
        ),
        AnimatedSize(
          duration: MyAppTheme.animationDuration,
          child: ValueListenableBuilder(
            valueListenable: _displayTransactionDetailsColumn,
            builder: (context, showTransactionDetails, _) {
              if(!MyAppTheme.isThreeColumnMode(context) || !showTransactionDetails) {
                return const SizedBox(
                  height: double.infinity,
                  width: 0,
                );
              }
              return Container(
                width: MyAppTheme.columnWidth,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                ),
                child: BlocProvider(
                  key: ValueKey(transactionId),
                  create: (_) => SubTransactionBloc(
                    friendId: widget.userModel.userId, 
                    transactionId: transactionId
                  ),
                  child: TransactionSubDetailsScreen(
                    key: ValueKey(transactionId),
                    transactionId: transactionId,
                    title: title,
                    closeButton: IconButton(
                      tooltip: localizations.close,
                      onPressed: () {
                        context.read<DashboardBloc>().add(DashboardTransactionDetailsWindowCloseEvent());
                        toggleTransactionDetailsColumn();
                      }, 
                      icon: const Icon(AppIcons.closeIcon)
                    ),
                  )
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}