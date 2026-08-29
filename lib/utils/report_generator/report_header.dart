import 'package:flutter/foundation.dart';
import 'package:my_wallet/utils/app_extension_method.dart';
import 'package:my_wallet/utils/report_generator/report_transaction_timeilne_header.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../constants/app_size.dart';
import '../../constants/app_strings.dart';

class ReportHeader extends pw.StatelessWidget {
  
  ReportHeader({
    required this.image,
    this.reportNo = '',
    this.isHeader = true
  });
  
  final Uint8List image;
  final String reportNo;
  final bool isHeader;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              AppStrings.transactionStatement,
              style: pw.TextStyle(
                color: PdfColors.black,
                fontSize: 12,
              ),
            ),
            if (!reportNo.isBlank)
              pw.Text(
                '${AppStrings.reportNo}: $reportNo',
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 12,
                ),
              ),
          ]
        ),
        pw.SizedBox(height: AppSize.s14),
        if (!isHeader) ...[
          ReportTransactionTimelineItemWidget()
        ]
      ],
    );
  }
}