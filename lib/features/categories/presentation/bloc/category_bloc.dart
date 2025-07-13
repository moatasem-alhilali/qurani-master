import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/categories/data/model/category_section_model.dart';
import 'package:quran_app/features/categories/data/model/category_video_model.dart';
import 'package:quran_app/features/categories/data/model/section_type_model.dart';
import 'package:quran_app/features/categories/data/remote/category_repository_imp.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({required this.repositoryImpl}) : super(CategoryState()) {
    on<GetCategoriesEvent>(index);

    on<GetCategoryDetailEvent>(categoryDetail);
    on<GetCategoryOptionEvent>(categoryDetailOptions);
    // on<SearchCategoryEvent>(search);

    on<SetStateEvent>(
      (event, emit) {
        emit(state.copyWith());
      },
    );
  }
  CategoryRepositoryImpl repositoryImpl;

  FutureOr<void> index(
    GetCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(categoryState: RequestState.loading));
    final resUrl = event.url.contains('viewitems')
        ? 'https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/categories/viewitems/${event.id}/showall/ar/showall/json'
        : 'https://api3.islamhouse.com/v3/paV29H2gm56kvLPy/categories/viewcat/${event.id}/ar/showall/json';

    if (resUrl.contains('viewitems')) {
      final result = await repositoryImpl.getCategories(resUrl);
      result.fold(
        (l) {
          emit(state.copyWith(categoryState: RequestState.error));
        },
        (r) {
          emit(
            state.copyWith(
              categoryState: RequestState.success,
              categories: r
                  .map(
                    (e) => CategorySectionModel(
                      apiUrl: e.apiUrl,
                      title: e.title,
                      dataType: e.datatype,
                      id: e.id,
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );
    } else {
      final result = await repositoryImpl.getCategories(resUrl);
      result.fold(
        (l) {
          emit(state.copyWith(categoryState: RequestState.error));
        },
        (r) {
          emit(
            state.copyWith(
              categoryState: RequestState.success,
              categories: r
                  .map(
                    (e) => CategorySectionModel(
                      apiUrl: e.apiUrl,
                      title: e.title,
                      dataType: e.datatype,
                      id: e.id,
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );
    }
  }

  FutureOr<void> categoryDetail(
    GetCategoryDetailEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(quranBooksState: RequestState.loading));
    final result = await repositoryImpl.categoryDetail(event.url);
    result.fold(
      (l) {
        emit(state.copyWith(quranBooksState: RequestState.error));
      },
      (r) {
        emit(
          state.copyWith(
            quranBooksState: RequestState.success,
            categoryDetail: r,
          ),
        );
      },
    );
  }

  FutureOr<void> categoryDetailOptions(
    GetCategoryOptionEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(quranBooksState: RequestState.loading));
    final result = await repositoryImpl.categoryDetailOptions(event.url);
    result.fold(
      (l) {
        emit(state.copyWith(quranBooksState: RequestState.error));
      },
      (r) {
        emit(
          state.copyWith(
            quranBooksState: RequestState.success,
            categoriesOptionsSearch: r,
            categoriesOptions: r,
          ),
        );
      },
    );
  }
}
