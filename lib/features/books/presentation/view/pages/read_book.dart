import 'package:flutter/material.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReadBook extends StatelessWidget {
  const ReadBook({super.key, this.url = ""});
  final String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        actions: [
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
            ),
          ),
        ],
      ),
      body: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey),
        ),
        child: SfPdfViewer.network(
          url,
          canShowPaginationDialog: true,
          canShowScrollStatus: true,
          interactionMode: PdfInteractionMode.pan,
        ),
      ),
    );
  }
}
