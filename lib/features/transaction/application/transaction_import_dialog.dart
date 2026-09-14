import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:excel_plus/excel_plus.dart' hide TextSpan;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/features/transaction/application/transaction_import_bloc/transaction_import_bloc.dart';
import 'package:my_wallet/features/transaction/domain/transaction_import_model.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_theme.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_style.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/custom_text.dart';
import '../../../constants/app_size.dart';
import '../../../utils/helper.dart';
import '../../../widgets/horizontal_dashline.dart';
import '../../../../utils/mobile_download.dart'
  if(dart.library.html) '../../../../utils/web_download.dart';

class TransactionImportDialog extends StatefulWidget {

  final String friendId;
  final Widget? closeButton;

  const TransactionImportDialog({
    super.key,
    required this.friendId,
    this.closeButton
  });

  @override
  State createState() => _TransactionImportDialogState();
}

class _TransactionImportDialogState extends State<TransactionImportDialog> with Helper {

  AppLocalizations? _localizations;
  List<ImportStatus> importStatusFlagList = [];
  int currentIndex = 0;
  final reportHeader = {'date','type','status', 'amount'};
  List<TransactionImportModel> importTransactionList = [];

  @override
  void initState() {
    importStatusFlagList = [
      ImportStatus(label: 'Upload', isCompleted: false),
      ImportStatus(label: 'Review'),
      ImportStatus(label: 'Clean'),
      // ImportStatus(label: 'Map'),
      ImportStatus(label: 'Confirm')
    ];
    importTransactionList.clear();
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionImportBloc>(
      create: (context) => TransactionImportBloc(friendId: widget.friendId),
      child: AlertDialog(
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSize.s15, 
          horizontal: AppSize.s18
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSize.s15),
        backgroundColor: Helper.isDark ? AppColors.dialogColorDark : AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s10)),
        content: SizedBox(
          width: MyAppTheme.columnWidth + 200,
          child: BlocConsumer<TransactionImportBloc, TransactionImportState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: 'Transaction Import',
                        textStyle: getSemiBoldStyle(),
                      ),
                      Transform.translate(
                        offset: const Offset(10, 0),
                        child: IconButton(
                          tooltip: _localizations!.close,
                          onPressed: () => context.pop(),
                          icon: const Icon(AppIcons.clearIcon),
                          visualDensity: VisualDensity.compact
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSize.s16),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            importStatusFlagList.length, 
                            (index) {
                              final item = importStatusFlagList[index];
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 5,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: item.isCompleted
                                      ? AppColors.green
                                      : currentIndex == index
                                        ? AppColors.primaryColor
                                        : AppColors.grey.withValues(alpha: 0.3),
                                      shape: BoxShape.circle
                                    ),
                                    child: item.isCompleted
                                    ? Icon(
                                        Icons.check,
                                        size: 15,
                                        color: AppColors.white,
                                      )
                                    : Center(
                                      child: Text(
                                        '${index + 1}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: currentIndex == index
                                          ? AppColors.white
                                          : AppColors.black
                                        ),
                                      ),
                                    )
                                  ),
                                  Text(
                                    item.label,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: item.isCompleted
                                      ? AppColors.green
                                      : currentIndex == index
                                        ? AppColors.primaryColor
                                        : AppColors.black
                                    ),
                                  ),
                                  if (index < importStatusFlagList.length - 1) ...[
                                    SizedBox(
                                      width: 60,
                                      child: HorizontalLine(
                                        color: Colors.grey,
                                        dashWidth: 5,
                                        dashSpace: 5,
                                        strokeWidth: 1.2,
                                      ),
                                    ),
                                    SizedBox(width: 5)
                                  ]
                                ],
                              );
                            }
                          )
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSize.s20),
                  DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      color: AppColors.primaryColor,
                      strokeWidth: 1.4,
                      dashPattern: const [10, 3], 
                      radius: const Radius.circular(12),
                    ),
                    child: Container(
                      height: 240,
                      decoration: BoxDecoration(
                        color: AppColors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 12,
                          children: [
                            Icon(
                              Icons.upload,
                              size: 28,
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Drag and drop or '
                                  ),
                                  TextSpan(
                                    text: 'select files',
                                    style: TextStyle(
                                      color: AppColors.primaryColor
                                    ),
                                    recognizer: TapGestureRecognizer()
                                    ..onTap = () async{
                                      await pickFile(context.read<TransactionImportBloc>());
                                      if (importTransactionList.isNotEmpty && context.mounted) {
                    
                                        context.read<TransactionImportBloc>().add(TransactionImportInitiateEvent(
                                          transactionImportList: importTransactionList
                                        ));
                                      }
                                    }
                                  )
                                ]
                              ),
                            ),
                            Text(
                              'Upload your transaction file in CSV or Excel (.xlsx) format.\nThe maximum file size allowed is 2 MB',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11
                              ),
                            ),
                            InkWell(
                              onTap: () => context.read<TransactionImportBloc>().add(TransactionImportDownloadTemplateEvent()),
                              child: Text(
                                'Download sample template',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Transform.translate(
                              offset: Offset(0, 5),
                              child: Icon(Icons.circle, size: 7, color: AppColors.grey)),
                            Expanded(
                              child: Text(
                                "Avoid re-uploading a file you've already imported — only exact matches are caught as duplicates, so edited or partial re-uploads may create repeat entries.",
                                style: TextStyle(
                                  fontSize: 12
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Transform.translate(
                              offset: Offset(0, 5),
                              child: Icon(Icons.circle, size: 7, color: AppColors.grey)),
                            Expanded(
                              child: Text(
                                "Your file must match the sample template format, or it will be rejected.",
                                style: TextStyle(
                                  fontSize: 12
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              );
            },
            listener: (_, state) {
              switch (state) {
                case TransactionImportStatusUpdateState _:
                  currentIndex = state.currentImportIndex;
                  break;
                default:
              }
            },
          ),
        ),
      ),
    );
  }


  Future<void> pickFile(TransactionImportBloc transactionImportBloc) async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx', 'xls']
      );
      if (file == null) return;
      final fileLength = await file.length();
      if(fileLength > 2000000 && context.mounted) {
        showSnackBar(context: context, title: AppStrings.error, message: AppStrings.fileSizeMsg);
        return;
      }
      // final fileName = file.name;
      final fileExtension = file.extension;
      final fileBytes = await file.readAsBytes();
      if (fileExtension == 'xlsx' || fileExtension == 'xls') {
        final excel = Excel.decodeBytes(fileBytes);
        final table = excel.tables[excel.tables.keys.first];
        if (table != null) {
          for (var row in table.rows) {
            print(row.map((cell) => cell?.value).toList());
          }
        }
      }
      if (fileExtension == 'csv') {
        importStatusFlagList[currentIndex].isCompleted = true;
        transactionImportBloc.add(TransactionImportStateUpdateEvent(currentImportIndex: currentIndex+=1));
        final csvString = utf8.decode(fileBytes);
        final csvConverterRowList = csv.decode(csvString);
        if (csvConverterRowList.isEmpty) return;
        final header = csvConverterRowList.first.map((item) => item.toString().toLowerCase()).toSet();
        if (csvConverterRowList.length < 6) {
          debugPrint("Imported file should be min of 5 data points");
          return;
        }
        if (header.length < 3) {
          debugPrint("Imported file is not proper");
          return;
        }
        if (!header.contains('date') || !header.contains('type') || !header.contains('amount')) {
          debugPrint('File header is not proper');
          return;
        }
        await Future.delayed(const Duration(seconds: 1));
        importStatusFlagList[currentIndex].isCompleted = true;
        transactionImportBloc.add(TransactionImportStateUpdateEvent(currentImportIndex: currentIndex+=1));
        int dateCellIndex = 0;
        int descriptionCellIndex = 0;
        int typeCellIndex = 0;
        int statusCellIndex = 0;
        int amountCellIndex = 0;
        importTransactionList.clear();
        for (var i = 0; i < csvConverterRowList.length; i++) {
          final row = csvConverterRowList[i];
          DateTime? date;
          String? type;
          String? amount;
          String? description;
          bool? status;
          for (var j = 0; j < row.length; j++) {
            String columnItem = row[j];
            if (i == 0) {
              columnItem = columnItem.toString().toLowerCase();
              switch (columnItem) {
                case 'date':
                  dateCellIndex = j;
                  break;
                case 'type':
                  typeCellIndex = j;
                  break;
                case 'amount':
                  amountCellIndex = j;
                  break;
                case 'description':
                  descriptionCellIndex = j;
                  break;
                case 'status':
                  statusCellIndex = j;
                  break;
              }
            } else {
              if (j == dateCellIndex) {
                date = parseFlexibleDate(columnItem);
              }
              if (j == descriptionCellIndex) {
                description = parseFlexibleDescription(columnItem);
              }
              if (j == typeCellIndex) {
                type = parseFlexibleType(columnItem);
              }
              if (j == statusCellIndex) {
                status = parseFlexibleStatus(columnItem);
              }
              if (j == amountCellIndex) {
                amount = _parseFlexibleAmount(columnItem);
              }
            }
          }
          if (amount == null || type == null || date == null) continue;
          final transactionImportModel = TransactionImportModel(
            amount: amount,
            date: date,
            type: type,
            description: description ?? '',
            isActive: status ?? true
          );
          importTransactionList.add(transactionImportModel);
        }
        await Future.delayed(const Duration(seconds: 1));
        importStatusFlagList[currentIndex].isCompleted = true;
        transactionImportBloc.add(TransactionImportStateUpdateEvent(currentImportIndex: currentIndex+=1));
      }
      debugPrint("checking");
      debugPrint('file picked successfully');
    } catch (e) {
      debugPrint('something went wrong');
    }
  }

  String parseFlexibleDescription(String? input) {
    final description = (input ?? '').trim();
    if (description.isEmpty) return '-';
    if (description.length > 100) {
      return description.substring(0, 100);
    }
    return description;
  }

  bool parseFlexibleStatus(String? input) {
    final status = (input ?? '').toLowerCase();
    if ({'active', 'true','false','inactive'}.contains(status)) {
      return status == 'active' || status == 'true'
      ? true
      : false;
    }
    return true;
  }

  String? _parseFlexibleAmount(String? input) {
    if (input == null || input.trim().isEmpty) return null;
    final value = double.tryParse(input.trim());
    if (value == null) return null;
    return value.ceil().toString();
  }

  String? parseFlexibleType(String? input) {
    final type = (input ?? '').toLowerCase();
    if (type == AppStrings.transfer.toLowerCase() || type == AppStrings.receive.toLowerCase()) {
      return type == AppStrings.transfer.toLowerCase() ? AppStrings.transfer : AppStrings.receive;
    }
    return null;
  }

  DateTime? parseFlexibleDate(String? input) {
    if (input == null || input.trim().isEmpty) return null;
    final value = input.trim();
    // Try YYYY-MM-DD first (unambiguous, ISO format)
    final isoMatch = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(value);
    if (isoMatch != null) {
      final year = int.parse(isoMatch.group(1)!);
      final month = int.parse(isoMatch.group(2)!);
      final day = int.parse(isoMatch.group(3)!);
      return _tryBuildDate(year, month, day);
    }
    // Try DD-MM-YYYY
    final dmyMatch = RegExp(r'^(\d{1,2})-(\d{1,2})-(\d{4})$').firstMatch(value);
    if (dmyMatch != null) {
      final day = int.parse(dmyMatch.group(1)!);
      final month = int.parse(dmyMatch.group(2)!);
      final year = int.parse(dmyMatch.group(3)!);
      return _tryBuildDate(year, month, day);
    }
    // Try DD/MM/YYYY (slash variant, mentioned in your earlier spec)
    final dmySlashMatch = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$').firstMatch(value);
    if (dmySlashMatch != null) {
      final day = int.parse(dmySlashMatch.group(1)!);
      final month = int.parse(dmySlashMatch.group(2)!);
      final year = int.parse(dmySlashMatch.group(3)!);
      return _tryBuildDate(year, month, day);
    }
    return null; // unrecognized format
  }

  /// Validates the components before constructing DateTime,
  /// since DateTime(2026, 13, 45) would otherwise silently roll over
  /// into an unexpected date instead of failing.
  DateTime? _tryBuildDate(int year, int month, int day) {
    if (month < 1 || month > 12) return null;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    if (day < 1 || day > daysInMonth) return null;
    return DateTime(year, month, day);
  }


}

class ImportStatus {
  String label;
  bool isCompleted;

  ImportStatus({
    this.label = '',
    this.isCompleted = false
  });
}