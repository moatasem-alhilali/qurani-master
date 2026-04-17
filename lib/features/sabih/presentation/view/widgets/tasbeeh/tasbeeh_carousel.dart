import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/confirm_delete_dialog_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';
import 'package:quran_app/features/sabih/data/request/subih_request.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/add_dhikr_dialog.dart';
import 'package:quran_app/features/sabih/presentation/view/widgets/dhikr_card.dart';

class TasbeehCarousel extends StatefulWidget {
  const TasbeehCarousel({super.key, required this.state});

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
    context.showBottomSheetUIHeader(
      child: BlocProvider.value(
        value: context.read<SabihBloc>(),
        child: AddDhikrDialog(subihToEdit: subih),
      ),
      title: 'تعديل الذكر',
      backgroundColor: context.scaffoldBackgroundColor,
    );
  }

  Future<void> _showDeleteConfirmation(SubihModel subih) async {
    final result = await showDeleteConfirmationDialog<bool>(context);

    if (result == true) {
      if (subih.id != null) {
        final request = SubihRequest.fromModel(subih);
        if (context.mounted) {
          context.read<SabihBloc>().add(DeleteSubihEvent(request: request));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < widget.state.subihList.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 8,
                  width: i == _currentPage ? 24 : 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i == _currentPage
                        ? context.primaryColor
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: context.getHight(60),
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.state.subihList.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              // Removed redundant GetCountsForPeriodEvent logic which caused entire today counts to refetch every swipe
            },
            itemBuilder: (context, index) {
              final subih = widget.state.subihList[index];
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
                          ResetTodayCounterEvent(
                            subihId: subih.id!,
                          ),
                        );
                  }
                },
                onEdit: subih.isCustom
                    ? () {
                        _showEditDhikrDialog(subih, context);
                      }
                    : null,
                onDelete: subih.isCustom
                    ? () {
                        _showDeleteConfirmation(subih);
                      }
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}
