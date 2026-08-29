import 'package:my_wallet/constants/app_strings.dart';
import 'package:my_wallet/utils/app_extension_method.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportTransactionTimelineItemWidget extends pw.StatelessWidget {

  final String label1;
  final String label2;
  final String label3;
  final String label4;
  final String label5;
  final PdfColor bgColor;
  final bool isHeader;

  ReportTransactionTimelineItemWidget({
    this.label1 = AppStrings.date,
    this.label2 = AppStrings.description,
    this.label3 = AppStrings.type,
    this.label4 = AppStrings.status,
    this.label5 = AppStrings.amount,
    this.bgColor = PdfColors.indigo,
    this.isHeader = true
  });
  
  @override
  pw.Widget build(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 1,
          child: pw.Container(
            padding: pw.EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: pw.BoxDecoration(
              color: bgColor,
              border: pw.TableBorder.all(
                width: 0.1,
                color: isHeader 
                ? PdfColors.white
                : PdfColors.grey300
              ),
            ),
            child: pw.Text(
              label1.isBlank ? '-' : label1,
              style: pw.TextStyle(
                fontSize: 9,
                color: isHeader
                ? PdfColors.white
                : PdfColors.grey900
              ),
            ),
          ),
        ),
        pw.Expanded(
          flex: 2,
          child: pw.Container(
            padding: pw.EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: pw.BoxDecoration(
              color: bgColor,
              border: pw.TableBorder.all(
                width: 0.1,
                color: isHeader 
                ? PdfColors.white
                : PdfColors.grey300
              ),
            ),
            child: pw.Text(
              label2.isBlank ? '-' : label2,
              textAlign: pw.TextAlign.start,
              style: pw.TextStyle(
                fontSize: 9,
                color: isHeader
                ? PdfColors.white
                : PdfColors.grey900
              ),
            ),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Container(
            padding: pw.EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: pw.BoxDecoration(
              color: bgColor,
              border: pw.TableBorder.all(
                width: 0.1,
                color: isHeader 
                ? PdfColors.white
                : PdfColors.grey300
              ),
            ),
            child: pw.Text(
              label3.isBlank ? '-' : label3,
              style: pw.TextStyle(
                fontSize: 9,
                color: isHeader
                ? PdfColors.white
                : label3.toLowerCase() == AppStrings.transfer.toLowerCase()
                  ? PdfColors.red
                  : PdfColors.green
              ),
            ),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Container(
            padding: pw.EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: pw.BoxDecoration(
              color: bgColor,
              border: pw.TableBorder.all(
                width: 0.1,
                color: isHeader 
                ? PdfColors.white
                : PdfColors.grey300
              ),
            ),
            child: pw.Text(
              label4.isBlank ? '-' : label4,
              style: pw.TextStyle(
                fontSize: 9,
                color: isHeader
                ? PdfColors.white
                : label4 == AppStrings.active
                  ? PdfColors.green
                  : PdfColors.red
              ),
            ),
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.Container(
            padding: pw.EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: pw.BoxDecoration(
              color: bgColor,
              border: pw.TableBorder.all(
                width: 0.1,
                color: isHeader 
                ? PdfColors.white
                : PdfColors.grey300
              ),
            ),
            child: pw.Text(
              label5.isBlank ? '-' : label5,
              style: pw.TextStyle(
                fontSize: 9,
                color: isHeader
                ? PdfColors.white
                : PdfColors.grey900
              ),
            ),
          ),
        ),
      ],
    );
  }
}