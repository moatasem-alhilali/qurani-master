// import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_home_widget.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/util/snack_bar.dart';
import 'package:quran_app/features/search/presentation/bloc/search_bloc.dart';

class SearchMosoaaScreen extends StatelessWidget {
  SearchMosoaaScreen({super.key});
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return BaseHomeWidget(
          leading: const SizedBox(),
          title: 'الذكاء الاصطناعي',
          bottomNavigationBar: MyTextFormFieldWidget(
            hintText: 'ابحث هنا',
            controller: search,
            suffixIcon: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                switch (state.searchMossoState) {
                  case RequestState.initial:
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
                      padding: EdgeInsets.all(8),
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
            context: context,
            title: 'لقد انتهى الحد اليومي لعدد الاسئلة',
          );
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
            final data = state.historySearchMosoaa[index];
            return state.historySearchMosoaa.isEmpty
                ? const SizedBox()
                : BaseAnimate(
                    index: index,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(),
                    ),
                  );
          },
        );
      },
    );
  }
}
