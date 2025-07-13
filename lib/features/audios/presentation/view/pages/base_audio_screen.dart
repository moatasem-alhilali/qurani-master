import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/base_home_widget.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/components/quran_widgets/feature_card_text_widget.dart';
import 'package:quran_app/core/extensions/request_state_extension.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/audios/data/remote/base_audio_repository_imp.dart';
import 'package:quran_app/features/audios/presentation/bloc/base_audio_bloc.dart';
import 'package:quran_app/features/audios/presentation/view/pages/base_audio_deatil.dart';

class BaseAudioScreen extends StatelessWidget {
  BaseAudioScreen({required this.id, required this.title, super.key});
  final String id;
  final String title;
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BaseAudioBloc(
        repositoryImpl: sl.get<BaseAudioRepositoryImpl>(),
      )..add(GetBaseAudioEvent(id)),
      child: BlocBuilder<BaseAudioBloc, BaseAudioState>(
        builder: (context, state) {
          return BaseHomeWidget(
            isScroll: false,
            title: title,
            body: BlocConsumer<BaseAudioBloc, BaseAudioState>(
              listener: (context, state) {},
              builder: (context, state) {
                return state.famousBaseAudioState.handle<dynamic>(
                  onSuccess: () => Column(
                    children: [
                      MyTextFormFieldWidget(
                        controller: search,
                        hintText: 'بحث',
                        suffixIcon: search.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  search.clear();
                                  context
                                      .read<BaseAudioBloc>()
                                      .add(SetStateEvent());
                                },
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                              ).animate().fade()
                            : null,
                        onChanged: (text) {
                          _onSearchTextChanged(state.baseAudio);
                          context.read<BaseAudioBloc>().add(SetStateEvent());
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount:
                              _onSearchTextChanged(state.baseAudio).length,
                          itemBuilder: (context, index) {
                            final allData =
                                _onSearchTextChanged(state.baseAudio)[index];
                            final randomShapeType = CardShapeType.values[
                                Random().nextInt(CardShapeType.values.length)];

                            return _Item(
                              allData,
                              randomShapeType,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  List<dynamic> _onSearchTextChanged(List data) {
    final res = data
        .where(
          (data) => data['title']
              .toString()
              .toLowerCase()
              .contains(search.text.toLowerCase()),
        )
        .toList();
    return res;
  }
}

class _Item extends StatelessWidget {
  const _Item(this.data, this.shapeType);
  final dynamic data;
  final CardShapeType shapeType;
  @override
  Widget build(BuildContext context) {
    return FeatureCardTextWidget(
      height: 100.h,
      onTap: () {
        context.push(BaseAudioDetail(data: data));
      },
      title: data['title'].toString(),
      width: double.infinity,
      shapeType: shapeType,
      // withBackground: false,
    );
  }
}
