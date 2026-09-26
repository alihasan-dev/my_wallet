import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../constants/app_size.dart';
import '../../constants/app_strings.dart';

class ReportFooter extends pw.StatelessWidget {
  
  ReportFooter({
    required this.currentPage,
    required this.totalPage,
    required this.image,
  });
  final int currentPage;
  final int totalPage;
  final Uint8List image;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Divider(color: PdfColors.grey500, height: 0.5, thickness: 0.5),
        pw.SizedBox(height: AppSize.s1),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Row(
              children: [
                pw.Image(
                  pw.MemoryImage(image),
                  width: AppSize.s30,
                  height: AppSize.s30
                ),
                pw.SizedBox(width: AppSize.s1),
                pw.Text(
                  AppStrings.appName,
                  style: pw.TextStyle(
                    color: PdfColors.grey700,
                    fontSize: 11,
                  ),
                )
              ],
            ),
            pw.Text(
              "Page $currentPage of $totalPage",
              style: pw.TextStyle(
                fontSize: 11,
                color: PdfColors.grey700,
              ),
            )
          ]
        )
      ],
    );
  }
}