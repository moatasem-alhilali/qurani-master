import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/categories/data/category_repository_imp.dart';
import 'package:quran_app/main.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryRepositoryImpl repositoryImpl;

  CategoryBloc({required this.repositoryImpl}) : super(CategoryState()) {
    on<GetCategoryEvent>(index);

    on<GetQuranBookEvent>(detail);
    // on<SearchCategoryEvent>(search);

    on<SetStateEvent>(
      (event, emit) {
        emit(state.copyWith());
      },
    );
  }

  FutureOr<void> index(event, emit) async {
    emit(state.copyWith(famousCategoryState: RequestState.loading));
    var result = await repositoryImpl.categoriesData(event.id, event.url);
    result.fold(
      (l) {
        emit(state.copyWith(famousCategoryState: RequestState.error));
      },
      (r) {
        emit(
          state.copyWith(
            famousCategoryState: RequestState.success,
            famousCategory: r,
          ),
        );
      },
    );
  }



  FutureOr<void> detail(event, emit) async {
    emit(state.copyWith(quranBooksState: RequestState.loading));
    var result = await repositoryImpl.categoryDetail(event.url);
    result.fold(
      (l) {
        emit(state.copyWith(quranBooksState: RequestState.error));
      },
      (r) {
        emit(
          state.copyWith(
            quranBooksState: RequestState.success,
            quranBooksDetail: r,
            quranBooksDetailSearch: r['data'],
          ),
        );
      },
    );
  }

  
}
