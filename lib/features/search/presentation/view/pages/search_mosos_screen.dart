import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/util/snack_bar.dart';
import 'package:quran_app/features/search/data/search_repository_imp.dart';
import 'package:quran_app/features/search/presentation/bloc/search_bloc.dart';

class SearchMosoaaScreen extends StatelessWidget {
  SearchMosoaaScreen({super.key});
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(
        repositoryImpl: sl.get<SearchRepositoryImpl>(),
      )..add(GetHistoryMosoaaEvent()),
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return BaseHome(
            leading: const SizedBox(),
            title: "الذكاء الاصطناعي",
            bottomNavigationBar: MyTextFormField(
              hintText: "ابحث هنا",
              controller: search,
              suffixIcon: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  switch (state.searchMossoState) {
                    case RequestState.defaults:
                      return IconButton(
                        onPressed: () {
                          if (search.text.isNotEmpty) {
                            context
                                .read<SearchBloc>()
                                .add(SearchMosoaaEvent(search.text));
                          }
                        },
                        icon: const Icon(Icons.send),
                      );

                    case RequestState.loading:
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.transparent,
                          child: CircularProgressIndicator(),
                        ),
                      );

                    case RequestState.error:
                      return IconButton(
                        onPressed: () {
                          if (search.text.isNotEmpty) {
                            context
                                .read<SearchBloc>()
                                .add(SearchMosoaaEvent(search.text));
                          }
                        },
                        icon: const Icon(Icons.send),
                      );
                    case RequestState.success:
                      return IconButton(
                        onPressed: () {
                          if (search.text.isNotEmpty) {
                            context
                                .read<SearchBloc>()
                                .add(SearchMosoaaEvent(search.text));
                          }
                        },
                        icon: const Icon(Icons.send),
                      );
                  }
                },
              ),
            ),
            body: Column(
              children: [
                BlocConsumer<SearchBloc, SearchState>(
                  listener: (context, state) {
                    if (state.searchMossoState == RequestState.success) {
                      search.clear();
                    }
                  },
                  builder: (context, state) {
                    return _Item();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Item extends StatelessWidget {
  _Item();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state.searchMossoState == RequestState.success) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
        if (state.searchMossoState == RequestState.error) {
          SnackBarMessage.show(
              context: context, title: "لقد انتهى الحد اليومي لعدد الاسئلة");
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
      builder: (context, state) {
        return ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: state.historySearchMosoaa.length,
          itemBuilder: (context, index) {
            var data = state.historySearchMosoaa[index];
            return state.historySearchMosoaa.isEmpty
                ? const SizedBox()
                : BaseAnimate(
                    index: index,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          BubbleSpecialThree(
                            text: data['question'],
                            color: const Color(0xFF6e57dd),
                            tail: true,
                            textStyle: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                          BubbleSpecialThree(
                            text: data['answer'],
                            color: const Color(0xFF283643),
                            isSender: false,
                            textStyle: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
          },
        );
      },
    );
  }
}
