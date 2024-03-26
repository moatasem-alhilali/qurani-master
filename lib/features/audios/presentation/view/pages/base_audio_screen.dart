import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_item_book.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/ui_screen.dart';
import 'package:quran_app/features/audios/data/base_audio_repository_imp.dart';
import 'package:quran_app/features/audios/presentation/bloc/base_audio_bloc.dart';
import 'package:quran_app/features/audios/presentation/view/pages/base_audio_deatil.dart';

class BaseAudioScreen extends StatelessWidget {
  BaseAudioScreen({super.key, required this.id, required this.title});
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
          return BaseUiScreen(
            onRefresh: () async {},
            title: Text(title),
            child: BlocConsumer<BaseAudioBloc, BaseAudioState>(
              listener: (context, state) {},
              builder: (context, state) {
                switch (state.famousBaseAudioState) {
                  case RequestState.defaults:
                    return const SizedBox();
                  case RequestState.loading:
                    return const CircularProgressIndicator();
                  case RequestState.error:
                    return const SizedBox();
                  case RequestState.success:
                    return Column(
                      children: [
                        MyTextFormField(
                          controller: search,
                          hintText: "بحث",
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
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                _onSearchTextChanged(state.baseAudio).length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1 / 1.5,
                            ),
                            itemBuilder: (context, index) {
                              var allData =
                                  _onSearchTextChanged(state.baseAudio)[index];

                              return _Item(allData);
                            },
                          ),
                        ),
                      ],
                    );
                }
              },
            ),
          );
        },
      ),
    );
  }

  List<dynamic> _onSearchTextChanged(List data) {
    final res = data
        .where((data) => data['title']
            .toString()
            .toLowerCase()
            .contains(search.text.toLowerCase()))
        .toList();
    return res;
  }
}

class _Item extends StatelessWidget {
  const _Item(this.data);
  final dynamic data;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        // color: Colors.red,
      ),
      child: Column(
        children: [
          Expanded(
            child: BaseBookItem(
              data['title'],
              () {
                context.push(BaseAudioDetail(data: data));
              },
            ),
          ),
        ],
      ),
    );
  }
}
