import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/services/download_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/services/url_launcher_service.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/widgets/custom_video_player.dart';
import 'package:quran_app/features/books/presentation/view/pages/read_book.dart';
import 'package:quran_app/features/categories/data/model/category_video_model.dart';
import 'package:quran_app/features/categories/data/remote/category_repository_imp.dart';
import 'package:quran_app/features/categories/presentation/bloc/category_bloc.dart';
import 'package:quran_app/features/categories/presentation/view/widgets/category_skin_widgets.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';

/// تفاصيل مادة واحدة: وصفها ثم مرفقاتها صفوفًا نحيلة.
class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({required this.category, super.key});

  final CategoryDetailModel category;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocProvider(
      create: (context) => CategoryBloc(
        repositoryImpl: sl.get<CategoryRepositoryImpl>(),
      )..add(GetCategoryDetailEvent(category.apiUrl ?? '')),
      child: Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          buildWhen: (previous, current) =>
              previous.categoryDetail != current.categoryDetail,
          builder: (context, state) {
            return AppScaffoldWidget(
              title: state.categoryDetail?.title ?? category.title ?? '',
              onRefresh: () async {
                context
                    .read<CategoryBloc>()
                    .add(GetCategoryDetailEvent(category.apiUrl ?? ''));
              },
              slivers: [
                SliverToBoxAdapter(
                  child: ColoredBox(
                    color: skin.ground,
                    child: _DetailHeader(detail: state.categoryDetail),
                  ),
                ),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    return state.quranBooksState.whenSliver<dynamic>(
                      onLoading: const CategoryThinLoader(),
                      onSuccess: () {
                        final items =
                            state.categoryDetail?.attachments ?? const [];

                        if (items.isEmpty) {
                          return const SliverToBoxAdapter(
                            child: CategoryNotice(
                              message: 'لا توجد مرفقات لهذه المادة.',
                            ),
                          );
                        }

                        return SliverList.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return ColoredBox(
                              color: skin.ground,
                              child: _AttachmentRow(
                                data: items[index],
                                isLast: index == items.length - 1,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.detail});

  final CategoryDetailModel? detail;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final description = (detail?.description ?? '').trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (description.isNotEmpty)
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
            child: Text(
              description,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.85),
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w500,
                height: 1.65,
              ),
            ),
          ),
        skin.divider(),
        const HomeSectionHeader(title: 'المرفقات'),
      ],
    );
  }
}

/// صفّ مرفق: نوعه في مربّع صغير، ثم وصفه وحجمه، ثم فعلاه.
class _AttachmentRow extends StatefulWidget {
  const _AttachmentRow({required this.data, required this.isLast});

  final Attachment data;
  final bool isLast;

  @override
  State<_AttachmentRow> createState() => _AttachmentRowState();
}

class _AttachmentRowState extends State<_AttachmentRow> {
  final DownloadService _downloadService = DownloadService();

  @override
  void initState() {
    super.initState();
    _downloadService.init();
  }

  @override
  void dispose() {
    _downloadService.remove();
    super.dispose();
  }

  bool get _allowDownload {
    final type = widget.data.extensionType;
    return type != 'YOUTUBE' && type != 'LINK';
  }

  bool get _allowOpen {
    final type = widget.data.extensionType;
    return type == 'PDF' ||
        type == 'MP4' ||
        type == 'LINK' ||
        type == 'YOUTUBE';
  }

  String get _openLabel {
    switch (widget.data.extensionType) {
      case 'MP4':
      case 'YOUTUBE':
        return 'مشاهدة';
      case 'PDF':
        return 'قراءة';
      case 'LINK':
        return 'فتح';
      default:
        return '';
    }
  }

  HugeIconData get _typeIcon {
    switch (widget.data.extensionType) {
      case 'MP4':
      case 'YOUTUBE':
        return AppIcons.play;
      case 'PDF':
        return AppIcons.menuBook;
      case 'LINK':
        return AppIcons.link;
      default:
        return AppIcons.download;
    }
  }

  Future<void> _open() async {
    final url = widget.data.url;
    if (url == null || url.isEmpty) return;

    switch (widget.data.extensionType) {
      case 'PDF':
        context.push(ReadBook(url: url));
      case 'MP4':
        await context.showBottomSheet(child: CustomVideoPlayer(url: url));
      case 'YOUTUBE':
      case 'LINK':
        await UrlLauncher.fLaunch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final description = (widget.data.description ?? '').trim();
    final size = (widget.data.size ?? '').trim();
    final type = widget.data.extensionType ?? '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: widget.isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: skin.iconChip,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: AppIcon(_typeIcon, color: skin.accent, size: 15.sp),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      description.isEmpty ? type : description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.ink,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                    Text(
                      [
                        if (type.isNotEmpty) type,
                        if (size.isNotEmpty) size,
                        if (widget.data.order != null)
                          'الترتيب ${widget.data.order}',
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.78),
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              if (_allowOpen)
                CategoryActionButton(
                  label: _openLabel,
                  icon: _typeIcon,
                  onTap: _open,
                ),
              if (_allowOpen && _allowDownload) SizedBox(width: 6.w),
              if (_allowDownload)
                CategoryActionButton(
                  label: 'تحميل',
                  icon: AppIcons.download,
                  isPrimary: false,
                  onTap: () {
                    final url = widget.data.url;
                    if (url == null || url.isEmpty) return;
                    HapticFeedback.selectionClick();
                    _downloadService.download(
                      url,
                      description.isEmpty ? 'مرفق' : description,
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
