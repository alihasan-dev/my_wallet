import 'dart:async';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:my_wallet/utils/helper.dart';
import 'package:pdf/pdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../constants/app_audio.dart';
import '../../../../constants/app_images.dart';
import '../../../../features/transaction/domain/transaction_model.dart';
import '../../../../utils/app_extension_method.dart';
import '../../../../constants/app_strings.dart';
import '../../../../utils/check_connectivity.dart';
import '../../../../utils/preferences.dart';
import '../../../../utils/mobile_download.dart'
  if(dart.library.html) '../../../../utils/web_download.dart';
import '../../../../utils/report_generator/report_filter_details.dart';
import '../../../../utils/report_generator/report_footer.dart';
import '../../../../utils/report_generator/report_header.dart' show ReportHeader;
import '../../../../utils/report_generator/report_settlement_status.dart';
import '../../../../utils/report_generator/report_transaction_insights.dart';
import '../../../../utils/report_generator/report_transaction_timeilne_header.dart';
import '../../../../utils/report_generator/report_user_details.dart';
import '../../../dashboard/application/bloc/dashboard_bloc.dart';
import '../../domain/transaction_details_model.dart';
part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  // late DateFormat dateFormat;
  late CheckConnectivity checkConnectivity;
  late DocumentReference firebaseStoreInstance;
  late StreamSubscription<QuerySnapshot> streamDocumentSnapshot;
  var listTransactionResult = <TransactionModel>[];
  var originalTransactionResultList = <TransactionModel>[];
  final String userName;
  final DashboardBloc dashboardBloc;
  final String friendId;
  bool hasFilterApplied = false;
  bool amountAscending = true;
  bool typeAscending = true;
  bool dateAscending = true;
  late DateFormat dateFormat;
  String userId = '';
  late AudioPlayer audioPlayer;
  int lastTransactionDate = 0;
  Map? friendProfileData;
  double totalBalance = 0.0;
  int transferCount = 0;
  int receiveCount = 0;
  double transferAmount = 0.0;
  double receiveAmount = 0.0;
  int activeCount = 0;
  TransactionApplyFilterEvent? filterStatus;

  TransactionBloc({required this.userName, required this.friendId, required this.dashboardBloc}) : super(TransactionInitialState()) {
    dateFormat = DateFormat.yMMMd();
    userId = Preferences.getString(key: AppStrings.prefUserId);
    firebaseStoreInstance = FirebaseFirestore.instance.collection('users').doc(userId).collection('friends').doc(friendId);
    checkConnectivity = CheckConnectivity();
    _initializeAudioPlayer();
    on<TransactionAddEvent>(_onAddTransaction);
    on<TransactionDateChangeEvent>(_onChangeDateStatus);
    on<TransactionTypeChangeEvent>(_onChangeTransactionType);
    on<TransactionStatusChangeEvent>(_onChangeTransactionStatus);
    on<TransactionAmountChangeEvent>(_onChangeAmount);
    on<TransactionAllEvent>(_allTransactionData);
    on<TransactionDateSortEvent>(_onSortTransactionDate);
    on<TransactionAmountSortEvent>(_onSortTransactionAmount);
    on<TransactionTypeSortEvent>(_onSortTransactionType);
    on<TransactionScrollEvent>(_onScrollList);
    on<TransactionExportPDFEvent>(_onExportPDF);
    on<TransactionProfileUpdateEvent>(_onUpdateProfile);
    on<TransactionFilterEvent>(_onEnableFilter);
    on<TransactionChangeAmountRangeEvent>(_onChangeAmountRange);
    on<TransactionApplyFilterEvent>(_onApplyFilter);
    on<TransactionClearFilterEvent>(_onClearFilter);
    on<TransactionSelectListItemEvent>(_onSelectListItemEvent);
    on<TransactionDeleteEvent>(_onDeleteTransaction);
    on<TransactionEditEvent>(_onEditTransaction);
    on<TransactionActiveEvent>(_onActiveInActiveTransaction);
    on<TransactionClearSelectionEvent>(_onClearSelectionTransactionEvent);
    on<TransactionShowDetailsEvent>(_onShowTransactionDetails);
    on<TransactionClearTransactionIdEvent>(_onClearTransactionId);

    ///get last transaction time initially 
    firebaseStoreInstance.get().then((data) {
      friendProfileData = data.data() as Map?;
      if ((friendProfileData ?? {}).isNotEmpty) {
        lastTransactionDate = friendProfileData!['lastTransactionTime'] == null
        ? -1
        : friendProfileData!['lastTransactionTime'].millisecondsSinceEpoch;
      }
    });

    dashboardBloc.stream.listen((event) {
      if (isClosed) return;
      if(event is DashboardAllUserState) {
        final userState = event;
        var userEvent = userState.allUser.where((item) => item.userId == friendId).toList();
        if(userEvent.isNotEmpty) {
          lastTransactionDate = userEvent.first.lastTransactionDate;
          add(TransactionProfileUpdateEvent(userName: userEvent.first.name, profileImage: userEvent.first.profileImg));
        }
      }
      if (event is DashboardTransactionDetailsWindowCloseState) {
        add(TransactionClearTransactionIdEvent());
      }
    });

    streamDocumentSnapshot = firebaseStoreInstance.collection('transactions').snapshots().listen((event) {
      originalTransactionResultList.clear();
      for (var item in event.docs) {
        var mapData = item.data();
        if (mapData.isNotEmpty) {
          originalTransactionResultList.add(TransactionModel(
            id: item.id,
            date: DateTime.fromMillisecondsSinceEpoch(mapData['date'].millisecondsSinceEpoch),
            type: mapData['type'],
            amount: double.parse(mapData['amount']),
            isActive: mapData['isActive'] ?? true,
            description: mapData['description'] ?? ''
          ));
        }
      }
      add(TransactionAllEvent());
    });
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    streamDocumentSnapshot.cancel();
    return super.close();
  }

  void _onClearTransactionId(TransactionClearTransactionIdEvent event, Emitter emit) {
    emit(TransactionClearTransactionIdState());
  }

  void _initializeAudioPlayer() => audioPlayer = AudioPlayer();

  void _onShowTransactionDetails(TransactionShowDetailsEvent event, Emitter emit) {
    if(!event.transactionId.isBlank) {
      emit(TransactionShowDetailsState(transactionId: event.transactionId, title: event.title));
    }
  }

  void _onClearSelectionTransactionEvent(TransactionClearSelectionEvent event, Emitter emit) {
    if(listTransactionResult.isNotEmpty) {
      for (var item in listTransactionResult) {
        item.selected = false;
      }
      double balance = _totalBalance(transactionList: listTransactionResult);
      emit(AllTransactionState(
        listTransaction: listTransactionResult, 
        totalBalance: balance, 
        isFilterEnable: hasFilterApplied
      ));
    }
  }

  void _onEditTransaction(TransactionEditEvent event, Emitter emit) {
    if (listTransactionResult.isNotEmpty) {
      final selectedTransaction = listTransactionResult.firstWhere((element) => element.selected, orElse: () => TransactionModel.empty());
      if (selectedTransaction.id.isBlank) return;
      emit(TransactionEditState(selectedTransaction: selectedTransaction));
    }
  }

  void _onActiveInActiveTransaction(TransactionActiveEvent event, Emitter emit) {
    if (listTransactionResult.isNotEmpty) {
      final selectedTransaction = listTransactionResult.firstWhere((element) => element.selected, orElse: () => TransactionModel.empty());
      if (selectedTransaction.id.isBlank) return;
      firebaseStoreInstance.collection('transactions').doc(selectedTransaction.id).update({
        'isActive': !selectedTransaction.isActive
      });
      emit(TransactionActiveInActiveState(
        message: 'Transaction status updated successfully'
      ));
    }
  }

  Future<void> _onDeleteTransaction(TransactionDeleteEvent event, Emitter emit) async {
    if(listTransactionResult.isNotEmpty) {
      final batch = FirebaseFirestore.instance.batch();
      final savedLastTransaction = DateTime.fromMillisecondsSinceEpoch(lastTransactionDate);
      bool isLastTransactionDeleting = false;
      for(final transaction in listTransactionResult) {
        if(transaction.selected) {
          if (transaction.date.compareTo(savedLastTransaction) == 0) isLastTransactionDeleting = true;
          final docRef = firebaseStoreInstance.collection('transactions').doc(transaction.id);
          batch.delete(docRef);
        }
      }
      try {
        await batch.commit();
        log("Documents deleted successfully");
        if (isLastTransactionDeleting) {
          firebaseStoreInstance.update({'amount': 'deleted'});
        }
      } catch (e) {
        log("Error deleting documents: $e");
      }
    }
  }

  Future<void> _onSelectListItemEvent(TransactionSelectListItemEvent event, Emitter emit) async {
    if (listTransactionResult.isNotEmpty) {
      listTransactionResult[event.index].selected = !listTransactionResult[event.index].selected;
      double balance = _totalBalance(transactionList: listTransactionResult);
      emit(AllTransactionState(
        listTransaction: listTransactionResult, 
        totalBalance: balance, 
        isFilterEnable: hasFilterApplied
      ));
    }
  }

  void _onChangeAmountRange(TransactionChangeAmountRangeEvent event, Emitter emit) {
    emit(TransactionChangeAmountRangeState(rangeAmount: event.rangeAmount));
  }

  void _onScrollList(TransactionScrollEvent event, Emitter emit) {
    emit(TransactionScrollState(appbarSize: event.appbarSize));
  }

  void _onUpdateProfile(TransactionProfileUpdateEvent event, Emitter emit) {
    emit(TransactionProfileUpdateState(userName: event.userName, profileImage: event.profileImage));
  }

  void _onEnableFilter(TransactionFilterEvent event, Emitter emit) {
    emit(TransactionFilterState());
  }

  void _onClearFilter(TransactionClearFilterEvent event, Emitter emit) {
    if (event.clearFilter) {
      hasFilterApplied = false;
      filterStatus = null;
      listTransactionResult.clear();
      listTransactionResult.addAll(originalTransactionResultList);
      listTransactionResult.sort((a, b) => b.date.compareTo(a.date));
      double balance = _totalBalance(transactionList: listTransactionResult);
      emit(AllTransactionState(
        listTransaction: listTransactionResult, 
        totalBalance: balance, 
        isFilterEnable: hasFilterApplied
      ));
    }
  }

  void _onApplyFilter(TransactionApplyFilterEvent event, Emitter emit) {
    hasFilterApplied = true;
    filterStatus = event;
    listTransactionResult.clear();
    final startDateTime = event.dateTimeRange?.start;
    final endDateTime = event.dateTimeRange?.end;
    for(var item in originalTransactionResultList) {
      if (item.isActive && event.transactionStatus == AppStrings.inactive) continue;
      if (!item.isActive && event.transactionStatus == AppStrings.active) continue;
      if(event.dateTimeRange != null) {
        if(((item.date.isAfter(startDateTime!) || item.date.campareDateOnly(startDateTime)) && (item.date.isBefore(endDateTime!) || item.date.campareDateOnly(endDateTime))) && (item.amount >= event.amountRangeValues!.start  && item.amount <= event.amountRangeValues!.end) && (event.transactionType == AppStrings.all ? true : (item.type == event.transactionType))) {
          listTransactionResult.add(item);
        }
      } else {
        if((item.amount >= event.amountRangeValues!.start  && item.amount <= event.amountRangeValues!.end) && (event.transactionType == AppStrings.all ? true : (item.type == event.transactionType))) {
          listTransactionResult.add(item);
        }
      }
    }
    listTransactionResult.sort((a, b) => b.date.compareTo(a.date));
    double balance = _totalBalance(
      transactionList: listTransactionResult,
      considerActiveOnly: event.transactionStatus != AppStrings.inactive
    );
    emit(AllTransactionState(
      listTransaction: listTransactionResult, 
      totalBalance: balance, 
      isFilterEnable: true
    ));
  }

  void _allTransactionData(TransactionAllEvent event, Emitter emit) {
    listTransactionResult.clear();
    listTransactionResult.addAll(originalTransactionResultList);
    listTransactionResult.sort((a, b) => b.date.compareTo(a.date));
    double balance = _totalBalance(transactionList: listTransactionResult);
    emit(AllTransactionState(
      listTransaction: listTransactionResult, 
      totalBalance: balance, 
      isTransactionAgainstFilter: hasFilterApplied
    ));
  }

  void _onChangeDateStatus(TransactionDateChangeEvent event, Emitter emit) {
    emit(TransactionDateChangeState(false));
  }

  void _onChangeTransactionType(TransactionTypeChangeEvent event, Emitter emit) {
    emit(TransactionTypeChangeState(event.type));
  }

  void _onChangeTransactionStatus(TransactionStatusChangeEvent event, Emitter emit) {
    emit(TransactionStatusChangeState(event.status));
  }

  void _onChangeAmount(TransactionAmountChangeEvent event, Emitter emit) {
    if (event.amount.isBlank) {
      emit(TransactionAmountFieldState(errorAmountMsg: AppStrings.emptyAmount));
    } else {
      emit(TransactionAmountFieldState());
    }
  }

  void _onSortTransactionDate(TransactionDateSortEvent event, Emitter emit) {
    if (listTransactionResult.isNotEmpty) {
      if (dateAscending) {
        dateAscending = !dateAscending;
        listTransactionResult.sort((a, b) => a.date.compareTo(b.date));
      } else {
        dateAscending = !dateAscending;
        listTransactionResult.sort((a, b) => b.date.compareTo(a.date));
      }
      double balance = _totalBalance(transactionList: listTransactionResult);
      emit(AllTransactionState(
        listTransaction: listTransactionResult, 
        totalBalance: balance, 
        isFilterEnable: hasFilterApplied
      ));
    }
  }

  void _onSortTransactionAmount(TransactionAmountSortEvent event, Emitter emit) {
    if (listTransactionResult.isNotEmpty) {
      if (amountAscending) {
        amountAscending = !amountAscending;
        listTransactionResult.sort((a, b) => a.amount.compareTo(b.amount));
      } else {
        amountAscending = !amountAscending;
        listTransactionResult.sort((a, b) => b.amount.compareTo(a.amount));
      }
      double balance = _totalBalance(transactionList: listTransactionResult);
      emit(AllTransactionState(
        listTransaction: listTransactionResult, 
        totalBalance: balance, 
        isFilterEnable: hasFilterApplied
      ));
    }
  }

  void _onSortTransactionType(TransactionTypeSortEvent event, Emitter emit) {
    if (listTransactionResult.isNotEmpty) {
      if (typeAscending) {
        typeAscending = !typeAscending;
        listTransactionResult.sort((a, b) => a.type.compareTo(b.type));
      } else {
        typeAscending = !typeAscending;
        listTransactionResult.sort((a, b) => b.type.compareTo(a.type));
      }
      double balance = _totalBalance(transactionList: listTransactionResult);
      emit(AllTransactionState(
        listTransaction: listTransactionResult, 
        totalBalance: balance, 
        isFilterEnable: hasFilterApplied
      ));
    }
  }

  ///calculate total balance
  double _totalBalance({required List<TransactionModel> transactionList, bool considerActiveOnly = true}) {
    // return  transactionList.fold<double>(0.0, (previousValue, transaction) {
    // if (!transaction.isActive) return previousValue;
    // return transaction.type == AppStrings.transfer
    //     ? previousValue - transaction.amount
    //     : previousValue + transaction.amount;
    // });
    totalBalance = 0.0;
    transferCount = 0;
    receiveCount = 0;
    transferAmount = 0.0;
    receiveAmount = 0.0;
    activeCount = 0;
    for (final item in transactionList) {
      if (!item.isActive && considerActiveOnly) continue;
      activeCount+=1;
      switch (item.type) {
        case AppStrings.transfer:
          totalBalance-=item.amount;
          transferCount+=1;
          transferAmount+=item.amount;
          break;
        case AppStrings.receive:
          totalBalance+=item.amount;
          receiveCount+=1;
          receiveAmount+=item.amount;
          break;
        default:
      }
    }
    return totalBalance;
  }

  Future<void> _onAddTransaction(TransactionAddEvent event, Emitter<TransactionState> emit) async {
    if (await _validate(emit, userName: event.userName, date: event.date, amount: event.amount)) {
      if (event.transactionId.isBlank) {
        firebaseStoreInstance.collection('transactions').add({
          'date': event.date, 
          'amount': event.amount, 
          'type': event.type,
          'isActive': event.isActive,
          'description': event.description
        });
        var currentTransactionDateTime = event.date!; 
        try {
          final lastTransactionDateTime = DateTime.fromMillisecondsSinceEpoch(lastTransactionDate);
          if (lastTransactionDateTime.isBefore(currentTransactionDateTime) || lastTransactionDateTime.isAtSameMomentAs(currentTransactionDateTime)) {
            firebaseStoreInstance.update({
              'lastTransactionTime': currentTransactionDateTime,
              'amount': event.amount,
              'type': event.type
            });
          }
        } catch (_) {log('FAILED:::while comparing last transaction date with current transaction date');}
      } else {
        firebaseStoreInstance.collection('transactions').doc(event.transactionId).update({
          'date': event.date, 
          'amount': event.amount, 
          'type': event.type,
          'isActive': event.isActive,
          'description': event.description
        });
      }
    }
  }

  Future<bool>  _validate(Emitter<TransactionState> emit,{required String userName, DateTime? date, required String amount}) async {
    if (amount.isBlank) {
      emit(TransactionAmountFieldState(errorAmountMsg: AppStrings.emptyAmount));
      return false;
    } else if (int.parse(amount) <= 0) {
      emit(TransactionAmountFieldState(errorAmountMsg: "Invalid amount"));
      return false;
    } else if (date == null) {
      emit(TransactionDateChangeState(true));
      return false;
    } else if (userName.isBlank) {
      emit(TransactionUserNameFieldState(userNameMessage: AppStrings.emptyName));
      return false;
    } else if (!await checkConnectivity.hasConnection) {
      emit(TransactionFailedState(title: AppStrings.noInternetConnection,message: AppStrings.noInternetConnectionMessage));
      await Future.delayed(const Duration(seconds: 3), () => emit(TransactionFailedState(message: '', title: '')));
      return false;
    }
    return true;
  }

  Future<pw.Document> _generatePDFLayout({List<TransactionModel> transactionList = const []}) async {
    if (transactionList.isEmpty) throw Exception("Transactions not available");
    final img = await rootBundle.load(AppImages.appImage);
    final fontData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    final pw.Font regularFont = pw.Font.ttf(fontData);
    final imageBytes = img.buffer.asUint8List();
    final pdf = pw.Document();
    final friendName = friendProfileData?['name'];
    final reportNo = Helper.generateId(preffix: friendName);
    final sortingLabel = dateAscending ? 'Newest to Oldest' : 'Oldest to Newest';
    final hasDetailsEnable = Preferences.getBool(key: AppStrings.prefShowTransactionDetails);
    String transactionType = 'All';
    String transactionStatus = 'All';
    String dateRange = 'All';
    String amountRange = 'All';
    if (filterStatus != null) {
      transactionType = filterStatus!.transactionType;
      transactionStatus = filterStatus!.transactionStatus;
      if (filterStatus!.amountRangeValues != null) {
        final minAmount = filterStatus!.amountRangeValues!.start.toString().currencyFormat;
        final maxAmount = filterStatus!.amountRangeValues!.end.toString().currencyFormat;
        amountRange = '$minAmount - $maxAmount';
      }
      if (filterStatus!.dateTimeRange != null) {
        final dateFormatter = DateFormat.yMMMd();
        final startDate = dateFormatter.format(filterStatus!.dateTimeRange!.start);
        final endDate = dateFormatter.format(filterStatus!.dateTimeRange!.end);
        dateRange = '$startDate - $endDate';
      }
    }
    pdf.addPage(
      pw.MultiPage(
        maxPages: 1,
        margin: pw.EdgeInsets.all(24),
        build: (_) => [
          ReportUserDetails(
            userData: friendProfileData,
            font: regularFont
          ),
          pw.SizedBox(height: 5),
          ReportFilterDetails(
            transactionType: transactionType,
            transactionStatus: transactionStatus,
            dateRange: dateRange,
            amountRange: amountRange,
            sorting: sortingLabel,
            detailsFlag: hasDetailsEnable ? 'Enable' : 'Disable'
          ),
          pw.SizedBox(height: 5),
          ReportTransactionInsights(
            totalAmount: totalBalance, 
            totalCount: transactionList.length, 
            activeCount: activeCount, 
            transferAmount: transferAmount, 
            inactiveCount: transactionList.length - activeCount, 
            receiveAmount: receiveAmount,
            font: regularFont
          ),
          pw.SizedBox(height: 12),
          ReportSettlementStatus(
            friendName: friendName,
            totalBalance: totalBalance,
            font: regularFont
          ),
        ],
        header: (_) => ReportHeader(image: imageBytes, reportNo: reportNo),
        footer: (context) => ReportFooter(
           currentPage: context.pageNumber,
          totalPage: context.pagesCount, 
          image: imageBytes
        ),
      ),
    );
    pdf.addPage(
      pw.MultiPage(
        maxPages: 200,
        margin: pw.EdgeInsets.all(24),
        build: (_) => List.generate(
          transactionList.length,
          (index) {
            final item = transactionList[index];
            return ReportTransactionTimelineItemWidget(
              isHeader: false,
              bgColor: index % 2 == 0 
              ? PdfColors.grey100 
              : PdfColors.white,
              label1: dateFormat.format(item.date),
              label2: item.description,
              label3: item.type,
              label4: item.isActive ? 'Active' : 'Inactive',
              label5: item.amount.toString().currencyFormat
            );
          }
        ),
        header: (_) => ReportHeader(
          image: imageBytes, 
          reportNo: reportNo,
          isHeader: false
        ),
        footer: (context) => ReportFooter(
          currentPage: context.pageNumber,
          totalPage: context.pagesCount, 
          image: imageBytes
        ),
      ),
    );
    return pdf;
  }

  Future<void> _onExportPDF(TransactionExportPDFEvent event, Emitter emit) async {
    if(listTransactionResult.isNotEmpty) {
      emit(TransactionLoadingState());
      try {
        final pdf = await _generatePDFLayout(transactionList: listTransactionResult);
        var dateTime = DateTime.now();
        var first = userName.replaceAll(' ', '');
        var last = dateTime.toString().substring(0, 10).replaceAll('-', '');
        first = '${first}_$last.pdf';
        await downloadFile(bytes: await pdf.save(), downloadName: first).then((_) async {
          emit(TransactionExportPDFState(message: 'File downloaded successfully', isSuccess: true));
        });
        await audioPlayer.setAsset(AppAudio.downloadSound);
        audioPlayer.play();
      } catch (e) {
        emit(TransactionExportPDFState(message: 'Something went wrong while exporting your transaction report'));
      }
    }
  }
}
