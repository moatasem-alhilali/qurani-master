import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_fade_image.dart';
import 'package:quran_app/core/components/base_progress_button.dart';
import 'package:quran_app/core/components/base_smooth_page_indicator.dart';
import 'package:quran_app/core/services/download_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/core/widgets/ui_screen.dart';
import 'package:quran_app/features/books/data/book_repository_imp.dart';
import 'package:quran_app/features/books/presentation/bloc/book_bloc.dart';
import 'package:quran_app/features/books/presentation/view/pages/read_book.dart';

class BookDetail extends StatelessWidget {
  BookDetail({super.key, this.data});
  final dynamic data;
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookBloc(
        repositoryImpl: sl.get<BookRepositoryImpl>(),
      ),
      child: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          return BaseUiScreen(
            onRefresh: () async {},
            title: data['title'].toString().autoSize(
                  context,
                  maxLines: 2,
                  fontSize: 14,
                  textAlign: TextAlign.center,
                ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: context.getHight(34),
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: data['attachments'].length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: FxColors.third,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: _Item(
                                  data['attachments'][index],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  BaseSmoothPageIndicator(
                    controller: _controller,
                    count: data['attachments'].length,
                  ),
                  const SizedBox(height: 10),
                  Info(
                    data: {
                      "title": "الوصف",
                      "subtitle": data['description'],
                    },
                  ),
                  const SizedBox(height: 10),
                  Info(
                    data: {
                      "title": "المرجع",
                      "subtitle": data['prepared_by'][0]['title'],
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({super.key, this.data});
  final dynamic data;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: FxColors.third,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          data['title'].toString().autoSize(
                context,
              ),
          const SizedBox(height: 10),
          data['subtitle'].toString().autoSize(
                context,
                color: FxColors.primary,
                maxLines: 20,
              ),
        ],
      ),
    );
  }
}

class _Item extends StatefulWidget {
  const _Item(this.data);
  final dynamic data;
  @override
  State<_Item> createState() => _ItemState();
}

class _ItemState extends State<_Item> {
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
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(4),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.red,
          ),
          child: const BaseFadeImage(
            image:
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKNDgmghQNk_-gH-n4L_YzFBo6EeE5QOYpmWM_pUGgqWSNVLYNulaoD9JEoJ9xw0FoxjU&usqp=CAU",
            fit: BoxFit.contain,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: widget.data['description'].toString().autoSize(
                        context,
                        maxLines: 8,
                      ),
                ),
              ),
              InkWell(
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
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.data['size'],
                          style: titleMedium(context),
                        ),
                      ),
                      Container(
                        height: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          // color: DarkColors.customPrimary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: const Icon(Icons.picture_as_pdf),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyProgressButton(
                      borderRadius: 12,
                      text: "قراءة",
                      defaultColor: FxColors.secondary,
                      isBorderColor: true,
                      onPressed: () {
                        context.push(
                          ReadBook(
                            url: widget.data['url'],
                          ),
                        );
                      },
                      // border: Border.all(color: DarkColors.third),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
