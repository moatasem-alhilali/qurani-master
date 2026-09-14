import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/confirm_delete_dialog_widget.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/data/request/subih_request.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/add_dhikr_dialog.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/dhikr_card.dart';

class TasbeehCarousel extends StatefulWidget {
  const TasbeehCarousel({required this.state, super.key});

  final SabihState state;

  @override
  State<TasbeehCarousel> createState() => _TasbeehCarouselState();
}

class _TasbeehCarouselState extends State<TasbeehCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showEditDhikrDialog(SubihModel subih, BuildContext context) {
    showDhikrSheet(context, subihToEdit: subih);
  }

  Future<void> _showDeleteConfirmation(SubihModel subih) async {
    // نلتقط الـ bloc قبل الانتظار حتى لا نعبر فجوة غير متزامنة بالسياق.
    final bloc = context.read<SabihBloc>();
    final confirmed = await showDeleteConfirmationDialog<bool>(context);

    if ((confirmed ?? false) && subih.id != null) {
      bloc.add(DeleteSubihEvent(request: SubihRequest.fromModel(subih)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final items = widget.state.subihList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < items.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  height: 3.h,
                  width: i == _currentPage ? 18.w : 6.w,
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    color: i == _currentPage ? AppColors.gold : skin.hairline,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 430.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: items.length,
            onPageChanged: (index) {
              // تنقّل بين الأذكار يُحسّ كما يُحسّ التسبيح نفسه.
              HapticFeedback.selectionClick();
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final subih = items[index];
              final count = widget.state.getCountForSubih(subih.id ?? -1);

              return DhikrCardWidget(
                subih: subih,
                count: count,
                onTap: () {
                  if (subih.id != null) {
                    context.read<SabihBloc>().add(
                          PerformSubihTapEvent(subihId: subih.id!),
                        );
                  }
                },
                onReset: () {
                  if (subih.id != null) {
                    context.read<SabihBloc>().add(
                          ResetTodayCounterEvent(subihId: subih.id!),
                        );
                  }
                },
                onEdit: subih.isCustom
                    ? () => _showEditDhikrDialog(subih, context)
                    : null,
                onDelete: subih.isCustom
                    ? () => _showDeleteConfirmation(subih)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}
