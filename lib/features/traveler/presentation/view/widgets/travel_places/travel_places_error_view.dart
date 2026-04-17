import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_places/travel_places_bloc.dart';

class TravelPlacesErrorView extends StatelessWidget {
  const TravelPlacesErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelPlacesBloc, TravelPlacesState>(
      builder: (context, state) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded, size: 48.sp, color: context.errorColor),
                SizedBox(height: 16.h),
                Text(
                  state.errorMessage ?? 'حدث خطأ غير متوقع',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.h),
                FilledButton.icon(
                  onPressed: () => context.read<TravelPlacesBloc>().add(BootstrapPlacesEvent()),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('إعادة المحاولة'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
