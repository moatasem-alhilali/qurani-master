import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/books/data/book_repository_imp.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  BookRepositoryImpl repositoryImpl;
  ScrollController scrollController = ScrollController();
  int limit = 1;

  BookBloc({required this.repositoryImpl}) : super(BookState()) {
    on<GetBookEvent>(index);

    on<SetStateEvent>(
      (event, emit) {
        emit(state.copyWith());
      },
    );
  }

  FutureOr<void> index(event, emit) async {
    emit(state.copyWith(getState: RequestState.loading));
    var result = await repositoryImpl.index(1);
    result.fold(
      (l) {
        emit(state.copyWith(getState: RequestState.error));
      },
      (r) {
        emit(state.copyWith(getState: RequestState.success, books: r));
      },
    );
  }

  
}
