import 'package:flutter/material.dart';
import 'package:quran_app/features/quran/presentation/page/quran_pdf/page/pdf_read.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class SearchBarItem extends StatelessWidget {
  const SearchBarItem(
      {Key? key, required this.searchAyahResultModel, required this.index})
      : super(key: key);

  final dynamic searchAyahResultModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(PdfRead(page: searchAyahResultModel.page), context);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              searchAyahResultModel.ayah,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Color.fromARGB(255, 237, 235, 235),
                fontFamily: 'ios-3',
                wordSpacing: 3,
                height: 2,
                fontSize: 16,
              ),
            ),
            const Divider(color: Color.fromARGB(255, 195, 194, 194)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "إسم السورة : ${searchAyahResultModel.NameSurah}",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontFamily: 'ios-3',
                      wordSpacing: 3,
                      height: 2,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  "رقم الصفحة : ${searchAyahResultModel.page}",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontFamily: 'ios-3',
                    wordSpacing: 3,
                    height: 2,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "رقم الاية : ${searchAyahResultModel.numberOfAyah}",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontFamily: 'ios-3',
                    wordSpacing: 3,
                    height: 2,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
