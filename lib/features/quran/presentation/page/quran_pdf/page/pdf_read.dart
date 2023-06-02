import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdfx/pdfx.dart';
import 'package:quran_app/core/Home/cubit.dart';
import 'package:quran_app/core/Home/state.dart';
import 'package:quran_app/core/util/toast_manager.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class PdfRead extends StatefulWidget {
  PdfRead({Key? key, required this.page}) : super(key: key);
  final int page;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<PdfRead> {
  static const int _initialPage = 1;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;
  late PdfControllerPinch _pdfController;

  @override
  void initState() {
    _pdfController = PdfControllerPinch(
      document: PdfDocument.openAsset('assets/pdf/quran2.pdf'),
      initialPage: widget.page,
    );
    if (fabIsClicked) {
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openAsset('assets/pdf/quran2.pdf'),
        initialPage: pdfSurah,
      );
      fabIsClicked = false;
    }

    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            await CashHelper.setData(key: 'last_time', value: timeNow);
            await CashHelper.setData(key: 'last_date', value: dateNow);
            print('button back');

            return true;
          },
          child: Scaffold(
            bottomNavigationBar: Container(
              margin: const EdgeInsets.all(8),
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الصفحة الحالية:$_actualPageNumber',
                      style: titleSmall(context),
                    ),
                    Text(
                      ' عدد الصفحات:$_allPagesCount',
                      style: titleSmall(context),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                CashHelper.setData(key: 'pdfSurah', value: _actualPageNumber)
                    .then((value) {
                  ToastServes.showToast(message: 'تم حفظ العلامة');
                });
                pdfSurah = _actualPageNumber;
                HomeCubit.get(context).mySetState();
              },
              child: const Icon(
                Icons.bookmark,
                color: Colors.white,
                size: 30,
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 230, 229, 229),
            body: SafeArea(
              child: PdfViewPinch(
                onDocumentError: (ob) {
                  // return CircularProgressIndicator();
                },

                

                controller: _pdfController,
                onDocumentLoaded: (document) {
                  HomeCubit.get(context).mySetState();
                  _allPagesCount = document.pagesCount;
                },
                onPageChanged: (page) {
                  HomeCubit.get(context).mySetState();
                  _actualPageNumber = page;
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
