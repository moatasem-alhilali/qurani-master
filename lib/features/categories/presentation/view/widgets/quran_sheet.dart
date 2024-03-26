import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_progress_button.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/download_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/services/url_launcher_service.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/core/widgets/custom_video_player.dart';
import 'package:quran_app/features/books/presentation/view/pages/read_book.dart';
import 'package:quran_app/features/categories/data/category_repository_imp.dart';
import 'package:quran_app/features/categories/presentation/bloc/category_bloc.dart';
import 'package:quran_app/main.dart';

class QuranBooksDetail extends StatelessWidget {
  const QuranBooksDetail({super.key, this.data});
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.getHight(70),
      child: BlocProvider(
        create: (context) => CategoryBloc(
          repositoryImpl: sl.get<CategoryRepositoryImpl>(),
        )..add(GetQuranBookEvent(data['apiurl'])),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            switch (state.quranBooksState) {
              case RequestState.defaults:
                return const Center(child: CircularProgressIndicator());
              case RequestState.loading:
                return const Center(child: CircularProgressIndicator());

              case RequestState.error:
                return const Center(
                    child: CircularProgressIndicator(color: Colors.red));

              case RequestState.success:
                // logger.i(state.quranBooksDetail['attachments']);

                return state.quranBooksDetail['attachments'] == null ||
                        state.quranBooksDetail['attachments'].isEmpty
                    ? Center(
                        child: Text(
                          "لا يوجد بيانات",
                          style: titleMedium(context),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: state.quranBooksDetail['title']
                                .toString()
                                .autoSize(context, fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: state.quranBooksDetail['description']
                                .toString()
                                .autoSize(context,
                                    color: Colors.grey,
                                    maxLines: 5,
                                    fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Divider(color: Colors.grey),
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount:
                                  state.quranBooksDetail['attachments'].length,
                              itemBuilder: (context, index) {
                                var data = state.quranBooksDetail['attachments']
                                    [index];
                                return _ItemDownloaded(data: data);
                              },
                            ),
                          ),
                        ],
                      );
            }
          },
        ),
      ),
    );
  }
}

class _ItemDownloaded extends StatelessWidget {
  _ItemDownloaded({
    Key? key,
    this.data,
  }) : super(key: key);

  dynamic data;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (data['description'] != null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: data['description']
                      .toString()
                      .autoSize(context, maxLines: 5),
                ),
                const SizedBox(height: 10),
                const Divider(),
              ],
            ),
          _BtnDownload(data: data),
        ],
      ),
    );
  }
}

class _BtnDownload extends StatefulWidget {
  const _BtnDownload({
    required this.data,
  });

  final dynamic data;

  @override
  State<_BtnDownload> createState() => _BtnDownloadState();
}

class _BtnDownloadState extends State<_BtnDownload> {
  DownloadService downloadService = DownloadService();
  @override
  void initState() {
    super.initState();
    downloadService.init();
  }

  @override
  void dispose() {
    downloadService.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d(widget.data);
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              if (allowDownload())
                Expanded(
                  child: InkWell(
                    onTap: () {
                      final url = widget.data['url'];
                      final description = widget.data['description'];
                      downloadService.download(url, description);
                    },
                    child: Container(
                      height: context.getHight(6),
                      decoration: BoxDecoration(
                        color: FxColors.secondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: FxColors.primary,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: const Icon(Icons.download),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: widget.data['size']
                                .toString()
                                .autoSize(context, minFontSize: 10),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.data['extension_type'],
                              style: titleMedium(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 5),
              if (allowOpen())
                Expanded(
                  child: MyProgressButton(
                    borderRadius: 12,
                    text: titleType(),
                    defaultColor: FxColors.secondary,
                    isBorderColor: true,
                    onPressed: () async {
                      final res = widget.data['extension_type'];

                      //pdf
                      if (res == 'PDF') {
                        context.push(
                          ReadBook(url: widget.data['url']),
                        );
                        return;
                      }
                      //video
                      if (res == 'MP4') {
                        final url = widget.data['url'];
                        context.showBottomSheet(
                            child: CustomVideoPlayer(url: url));
                        return;
                      }

                      //YOUTUBE
                      if (res == 'YOUTUBE') {
                        final url = widget.data['url'];
                        await UrlLauncher.fLaunch(url);
                        return;
                      }

                      //App
                      if (res == 'LINK') {
                        final url = widget.data['url'];
                        await UrlLauncher.fLaunch(url);
                        return;
                      }
                    },
                    // border: Border.all(color: DarkColors.third),
                  ),
                ),
            ],
          ),
        ),
        if (widget.data['order'] != null) const SizedBox(width: 5),
        if (widget.data['order'] != null)
          CircleAvatar(
            radius: 15,
            child: FittedBox(child: Text(widget.data['order'].toString())),
          ),
      ],
    );
  }

  bool allowDownload() {
    final data = widget.data['extension_type'];
    if (data != "YOUTUBE" && data != 'LINK') return true;
    return false;
  }

  bool allowOpen() {
    final data = widget.data['extension_type'];
    if (data == "PDF" || data == 'MP4' || data == 'LINK' || data == 'YOUTUBE') {
      return true;
    }
    return false;
  }

  String titleType() {
    final data = widget.data['extension_type'];
    if (data == "MP4") return "مشاهده";
    if (data == "PDF") return "قراءه";
    if (data == "LINK") return "تحميل";
    if (data == "YOUTUBE") return "مشاهده";
    return "";
  }
}
