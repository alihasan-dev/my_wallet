import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel_plus/excel_plus.dart' hide TextSpan;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_theme.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_style.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/custom_text.dart';
import '../../../constants/app_size.dart';
import '../../../utils/helper.dart';
import '../../../widgets/horizontal_dashline.dart';

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

  @override
  void initState() {
    importStatusFlagList = [
      ImportStatus(label: 'Upload', isCompleted: false),
      ImportStatus(label: 'Configure'),
      ImportStatus(label: 'Clean'),
      ImportStatus(label: 'Map'),
      ImportStatus(label: 'Confirm')
    ];
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSize.s15, 
        horizontal: AppSize.s18
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSize.s15),
      backgroundColor: Helper.isDark ? AppColors.dialogColorDark : AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s10)),
      content: SizedBox(
        width: MyAppTheme.columnWidth + 200,
        child: Column(
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
            const SizedBox(height: AppSize.s15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FittedBox(
                child: Row(
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
            const SizedBox(height: AppSize.s15),
            Container(
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
                            ..onTap = () => pickFile()
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
                      onTap: () {
                        debugPrint('click here to download template');
                      },
                      child: Text(
                        'Download sample template',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> pickFile() async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx', 'xls']
      );
      if (file == null) return;
      final fileLength = await file.length();
      if(fileLength > 2000000 && context.mounted) {
        showSnackBar(context: context, title: 'AppStrings.error', message: 'AppStrings.imageSizeMsg');
        return;
      }
      final fileName = file.name;
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
        final csvString = utf8.decode(fileBytes);
        final csvConverter = csv.decode(csvString);
      }
      debugPrint("checking");
      debugPrint('file picked successfully');
    } catch (e) {
      debugPrint('something went wrong');
    }
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