import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/constants/app_strings.dart';
import 'package:my_wallet/constants/app_theme.dart';
import 'package:my_wallet/features/dashboard/application/bloc/dashboard_bloc.dart';
import 'package:my_wallet/features/dashboard/domain/user_model.dart';
import 'package:my_wallet/features/profile/application/profile_screen.dart';
import 'package:my_wallet/features/transaction/application/transaction_screen.dart';
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
  State<TransactionDetails> createState() => TransactionDetailsState();
}

class TransactionDetailsState extends State<TransactionDetails> {

  late final ValueNotifier<bool> _displayProfileColumn;

  @override
  void initState() {
    _displayProfileColumn = ValueNotifier(false);
    super.initState();
  }

  void toggleDisplayProfileColumn() {
    _displayProfileColumn.value = !_displayProfileColumn.value;
  } 

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BlocProvider(
            create: (_) => TransactionBloc(
              userName: widget.userModel.name, 
              friendId: widget.userModel.userId,
              dashboardBloc: widget.dashboardBloc
            ), 
            child: TransactionScreen(userModel: widget.userModel, transactionDetailsState:  this)
          )
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
                    tooltip: AppStrings.close,
                    onPressed: toggleDisplayProfileColumn, 
                    icon: const Icon(Icons.close)
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}