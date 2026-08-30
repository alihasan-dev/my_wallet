import 'package:my_wallet/utils/app_extension_method.dart';
import 'package:my_wallet/utils/helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../constants/app_size.dart';
import '../../constants/app_strings.dart';

class ReportUserDetails extends pw.StatelessWidget {
  
  final Map<dynamic, dynamic>? userData;
  final pw.Font font;

  ReportUserDetails({
    this.userData, 
    required this.font
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: double.maxFinite,
          padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey200
          ),
          child: pw.Text(
            AppStrings.userDetails,
            style: pw.TextStyle(
              color: PdfColors.black,
              fontSize: 10,
            ),
          ),
        ),
        pw.SizedBox(height: AppSize.s8),
        pw.Padding(
          padding: pw.EdgeInsets.symmetric(horizontal: 6),
          child: pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Expanded(child: _rowInfoTile(title: AppStrings.name, value: _getRowString(userData?['name']))),
                  pw.SizedBox(width: 20),
                  pw.Expanded(child: _rowInfoTile(title: AppStrings.reportDate, value: Helper.getFormattedDateTime())),
                ]
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                children: [
                  pw.Expanded(child: _rowInfoTile(title: AppStrings.id, value:  _getRowString(userData?['user_id']))),
                  pw.SizedBox(width: 20),
                  pw.Expanded(child: _rowInfoTile(title: AppStrings.currency, value: 'INR (\u20B9)', font: font)),
                ]
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                children: [
                  pw.Expanded(child: _rowInfoTile(title: AppStrings.email, value: _getRowString(userData?['email']))),
                  pw.SizedBox(width: 20),
                  pw.Expanded(child: _rowInfoTile(title: AppStrings.phone, value: '+91 ${userData?['phone'] ?? '-'}')),
                ]
              ),
            ]
          ),
        ),
      ],
    );
  }

  String _getRowString(String? value) {
    try {
      return (value ?? '').isBlank ? '-' : value!;
    } catch(_) {
      return '-';
    }
  }

  pw.Widget _rowInfoTile({
    required String title,
    required String value,
    pw.Font? font
  }) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 1,
          child: pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey700,
            ),
          ),
        ),
        pw.Expanded(
          flex: 2,
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.black,
              font: font
            ),
          ),
        ),
      ],
    );
  }
}