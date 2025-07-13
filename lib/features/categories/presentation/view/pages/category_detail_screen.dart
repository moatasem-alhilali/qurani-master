import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/base_home_widget.dart';
import 'package:quran_app/core/components/base_progress_button.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/request_state_extension.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/services/download_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/services/url_launcher_service.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/core/widgets/custom_video_player.dart';
import 'package:quran_app/features/books/presentation/view/pages/read_book.dart';
import 'package:quran_app/features/categories/data/model/category_video_model.dart';
import 'package:quran_app/features/categories/data/remote/category_repository_imp.dart';
import 'package:quran_app/features/categories/presentation/bloc/category_bloc.dart';

class CategoryDetailScreen extends StatelessWidget {
  CategoryDetailScreen({required this.category, super.key});
  final CategoryDetailModel category;
  TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BaseHomeWidget(
      isScroll: false,
      showBackground: false,
      body: BlocProvider(
        create: (context) => CategoryBloc(
          repositoryImpl: sl.get<CategoryRepositoryImpl>(),
        )..add(GetCategoryDetailEvent(category.apiUrl!)),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            return state.quranBooksState.handle<dynamic>(
              onSuccess: () => Column(
                children: [
                  CardWidget(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child:
                              state.categoryDetail?.title.toString().autoSize(
                                    context,
                                    fontSize: 20,
                                    maxLines: 2,
                                    minFontSize: 10,
                                  ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: state.categoryDetail?.description
                              .toString()
                              .autoSize(
                                context,
                                color: Colors.grey,
                                maxLines: 20,
                                fontSize: 14,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: context.primaryScheme,
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.categoryDetail!.attachments!.length,
                      itemBuilder: (context, index) {
                        final data = state.categoryDetail!.attachments![index];
                        return _ItemDownloaded(data: data);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

//

class _ItemDownloaded extends StatelessWidget {
  _ItemDownloaded({
    required this.data,
    super.key,
  });

  Attachment data;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          if (data.description != null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: data.description
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

  final Attachment data;

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
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              if (allowDownload())
                Expanded(
                  child: InkWell(
                    onTap: () {
                      final url = widget.data.url!;
                      final description = widget.data.description!;
                      downloadService.download(
                        url,
                        description,
                      );
                    },
                    child: Container(
                      height: context.getHight(6),
                      decoration: BoxDecoration(
                        color: context.primaryScheme,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: context.primaryScheme,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: const Icon(
                              Icons.download,
                              // color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: widget.data.size.toString().autoSize(
                                  context,
                                  minFontSize: 10,
                                  color: Colors.white,
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              widget.data.extensionType ?? '',
                              style: titleMedium(context).copyWith(
                                color: Colors.white,
                              ),
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
                    borderRadius: 8,
                    text: titleType(),
                    height: 40.h,
                    defaultColor: context.primaryScheme,
                    // isBorderColor: true,
                    onPressed: () async {
                      final res = widget.data.extensionType;

                      //pdf
                      if (res == 'PDF') {
                        context.push(
                          ReadBook(url: widget.data.url!),
                        );
                        return;
                      }
                      //video
                      if (res == 'MP4') {
                        final url = widget.data.url;
                        context.showBottomSheet(
                          child: CustomVideoPlayer(url: url!),
                        );
                        return;
                      }

                      //YOUTUBE
                      if (res == 'YOUTUBE') {
                        final url = widget.data.url;
                        await UrlLauncher.fLaunch(url!);
                        return;
                      }

                      //App
                      if (res == 'LINK') {
                        final url = widget.data.url;
                        await UrlLauncher.fLaunch(url!);
                        return;
                      }
                    },
                    // border: Border.all(color: DarkColors.third),
                  ),
                ),
            ],
          ),
        ),
        if (widget.data.order != null) const SizedBox(width: 5),
        if (widget.data.order != null)
          CircleAvatar(
            radius: 15,
            child: FittedBox(child: Text(widget.data.order.toString())),
          ),
      ],
    );
  }

  bool allowDownload() {
    final data = widget.data.extensionType;
    if (data != 'YOUTUBE' && data != 'LINK') return true;
    return false;
  }

  bool allowOpen() {
    final data = widget.data.extensionType;
    if (data == 'PDF' || data == 'MP4' || data == 'LINK' || data == 'YOUTUBE') {
      return true;
    }
    return false;
  }

  String titleType() {
    final data = widget.data.extensionType;
    if (data == 'MP4') return 'مشاهده';
    if (data == 'PDF') return 'قراءه';
    if (data == 'LINK') return 'تحميل';
    if (data == 'YOUTUBE') return 'مشاهده';
    return '';
  }
}
