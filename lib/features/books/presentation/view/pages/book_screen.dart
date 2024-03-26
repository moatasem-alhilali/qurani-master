import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_fade_image.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/core/widgets/ui_screen.dart';
import 'package:quran_app/features/books/data/book_repository_imp.dart';
import 'package:quran_app/features/books/presentation/bloc/book_bloc.dart';
import 'package:quran_app/features/books/presentation/view/pages/book_deatil.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookBloc(
        repositoryImpl: sl.get<BookRepositoryImpl>(),
      )..add(GetBookEvent()),
      child: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          return BaseUiScreen(
            onRefresh: () async {},
            title: const Text("كتب"),
            child: BlocConsumer<BookBloc, BookState>(
              listener: (context, state) {},
              builder: (context, state) {
                switch (state.getState) {
                  case RequestState.defaults:
                    return const SizedBox();
                  case RequestState.loading:
                    return const CircularProgressIndicator();
                  case RequestState.error:
                    return const SizedBox();
                  case RequestState.success:
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.books.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.5,
                      ),
                      itemBuilder: (context, index) {
                        return _Item(state.books[index]);
                      },
                    );
                }
              },
            ),
          );
        },
      ),
    );
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
            child: InkWell(
              onTap: () {
                context.push(BookDetail(data: data));
              },
              child: Stack(
                alignment: Alignment.bottomCenter,
                fit: StackFit.expand,
                children: [
                  const BaseFadeImage(
                    image:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKNDgmghQNk_-gH-n4L_YzFBo6EeE5QOYpmWM_pUGgqWSNVLYNulaoD9JEoJ9xw0FoxjU&usqp=CAU",
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [
                          Colors.grey.withOpacity(0.0),
                          Colors.black,
                        ],
                        stops: const [
                          0.20,
                          1,
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 12),
                      child: data['title'].toString().autoSize(
                            context,
                            maxLines: 5,
                            textAlign: TextAlign.center,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
