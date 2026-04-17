import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/sabih/presentation/bloc/sabih_bloc.dart';
import 'package:quran_app/features/sabih/presentation/view/pages/analytics_screen.dart';

class TasbeehAnalyticsHeader extends StatelessWidget {
  const TasbeehAnalyticsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseOnTap(
      onTap: () {
        context.push(
          BlocProvider.value(
            value: context.read<SabihBloc>(),
            child: const AnalyticsScreen(),
          ),
        );
      },
      child: CardWidget(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ملخص الذكر',
                style: context.bodyMedium?.copyWith(
                  color: context.primaryColor,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: context.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
