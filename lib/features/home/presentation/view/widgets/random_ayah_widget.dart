import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/text_styles_extension.dart';
import 'package:quran_app/features/home/presentation/bloc/random_ayah_bloc.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:quran_app/gen/fonts.gen.dart';

class RandomAyahWidget extends StatefulWidget {
  const RandomAyahWidget({
    super.key,
  });

  @override
  State<RandomAyahWidget> createState() => _RandomAyahWidgetState();
}

class _RandomAyahWidgetState extends State<RandomAyahWidget> {
  NewAyahModel? randomAyah;
  @override
  void initState() {
    randomAyah = context.read<RandomAyahBloc>().state.randomAyah;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<RandomAyahBloc>().add(RefreshRandomAyahEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RandomAyahBloc, RandomAyahState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.sp),
          child: Text(
            randomAyah?.text ?? '',
            style: context.labelMedium?.copyWith(
              fontFamily: FontFamily.scheherazade,
            ),
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}
