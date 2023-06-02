import 'package:flutter/material.dart';
import 'package:quran_app/features/quran/presentation/page/read/widget/all_surah_read_drawer.dart';
import 'package:quran_app/features/quran/presentation/page/read/widget/body_detail.dart';

import 'package:quran_app/features/quran/presentation/page/read/widget/custom_appbar.dart';

class QuranRead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(),
          drawer: const Drawer(
            backgroundColor: Colors.transparent,
            child: AllSurahReadDrawer(),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(),
                const BodyDetail(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
