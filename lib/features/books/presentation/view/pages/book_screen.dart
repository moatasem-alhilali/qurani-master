import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/books/data/remote/book_repository_imp.dart';
import 'package:quran_app/features/books/presentation/bloc/book_bloc.dart';
import 'package:quran_app/features/books/presentation/view/pages/book_deatil.dart';
import 'package:quran_app/features/books/presentation/view/widgets/book_row.dart';

/// قائمة الكتب.
///
/// كانت شبكة أغلفة، وكل غلاف صورة واحدة مكرّرة من الإنترنت لكل الكتب — زينة
/// لا تدلّ على شيء. صارت صفوفًا نحيلة يقرأ فيها العنوان مباشرة.
class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocProvider(
      create: (context) => BookBloc(
        repositoryImpl: sl.get<BookRepositoryImpl>(),
      )..add(GetBookEvent()),
      child: Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
        child: AppScaffoldWidget(
          title: 'كتب',
          body: ColoredBox(
            color: skin.ground,
            child: BlocBuilder<BookBloc, BookState>(
              builder: (context, state) {
                switch (state.getState) {
                  case RequestState.initial:
                  case RequestState.loading:
                    return const _BooksSkeleton();
                  case RequestState.error:
                    return const _BooksNote(text: 'تعذّر تحميل الكتب حاليًا.');
                  case RequestState.success:
                    if (state.books.isEmpty) {
                      return const _BooksNote(text: 'لا توجد كتب للعرض.');
                    }
                    return Column(
                      children: [
                        for (var i = 0; i < state.books.length; i++)
                          BookRow(
                            title: bookFieldOf(state.books[i], 'title'),
                            subtitle:
                                bookFieldOf(state.books[i], 'description'),
                            icon: AppIcons.book,
                            isLast: i == state.books.length - 1,
                            onTap: () => context.push(
                              BookDetail(data: state.books[i]),
                            ),
                          ),
                        SizedBox(height: 18.h),
                      ],
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// ملاحظة من سطر واحد بدل الشاشة الفارغة.
class _BooksNote extends StatelessWidget {
  const _BooksNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
      child: Row(
        children: [
          AppIcon(AppIcons.book, color: skin.accent, size: 15.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// هيكل انتظار بشكل الصفوف نفسها.
class _BooksSkeleton extends StatelessWidget {
  const _BooksSkeleton();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      children: List.generate(
        6,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: index == 5
              ? null
              : BoxDecoration(
                  border: Border(bottom: BorderSide(color: skin.hairline)),
                ),
          child: Row(
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: skin.hairline,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Container(
                  height: 9.h,
                  decoration: BoxDecoration(
                    color: skin.hairline,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
