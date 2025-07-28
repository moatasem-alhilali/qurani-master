import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:quran_app/core/components/confirm_delete_dialog_widget.dart';
import 'package:quran_app/core/extensions/request_state/request_state_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/models_public/current_audio_model.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/widgets/filled_button_widget.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/download_quran_audio_bloc/download_quran_audio_bloc.dart';
import 'package:quran_app/features/quran_audio/presentation/bloc/quran_audio_bloc/quran_audio_bloc.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';
import 'package:quran_app/features/search/data/database/quran_search_datasource.dart';

class AudioSearchBodyWidget extends StatefulWidget {
  const AudioSearchBodyWidget({
    required this.boxController,
    required this.textEditingController,
    super.key,
  });
  final BoxController boxController;
  final TextEditingController textEditingController;
  @override
  State<AudioSearchBodyWidget> createState() => _AudioSearchBodyWidgetState();
}

class _AudioSearchBodyWidgetState extends State<AudioSearchBodyWidget> {
  Timer? _debounceTimer;
  String _searchQuery = '';
  List<NewSurahModel> _filteredSurahs = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    widget.textEditingController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    final query = widget.textEditingController.text.trim();

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Set searching state
    if (query != _searchQuery) {
      setState(() {
        _isSearching = true;
      });
    }

    // Debounce search for better performance
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _searchQuery = query;
          _isSearching = false;
        });
      }
    });
  }

  List<NewSurahModel> _filterSurahs(List<NewSurahModel> surahs, String query) {
    if (query.isEmpty) return surahs;

    final normalizedQuery = query.toLowerCase().trim();

    final normalizedRemoveDiacriticsQuery = removeDiacritics(normalizedQuery);

    return surahs.where((surah) {
      // Search in Arabic name
      if (surah.nameAr
          .toLowerCase()
          .contains(normalizedRemoveDiacriticsQuery)) {
        return true;
      }

      // Search in English name
      if (surah.nameEn
              ?.toLowerCase()
              .contains(normalizedRemoveDiacriticsQuery) ??
          false) {
        return true;
      }

      // Search in translation
      if (surah.translation
              ?.toLowerCase()
              .contains(normalizedRemoveDiacriticsQuery) ??
          false) {
        return true;
      }

      // Search by surah number
      if (surah.surahNumber
          .toString()
          .contains(normalizedRemoveDiacriticsQuery)) {
        return true;
      }

      // Search by ayah count
      if (surah.ayahCount
          .toString()
          .contains(normalizedRemoveDiacriticsQuery)) {
        return true;
      }

      return false;
    }).toList();
  }

  //

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadQuranBloc, ReadQuranState>(
      builder: (context, readQuranState) {
        return readQuranState.loadQuranState.when<NewSurahModel>(
          onSuccess: () {
            final surahs = readQuranState.surahs;
            _filteredSurahs = _filterSurahs(surahs, _searchQuery);

            if (_isSearching) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (_filteredSurahs.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: _filteredSurahs.length,
              itemBuilder: (context, index) {
                final data = _filteredSurahs[index];
                return _ItemDownloaded(
                  data: data,
                  indexSurah: surahs.indexOf(data), // Use original index
                  boxController: widget.boxController,
                  searchQuery: _searchQuery,
                );
              },
              separatorBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    // right: 10,
                  ),
                  child: Divider(
                    // color: context.onPrimary.withAlpha(50),
                    height: 0.5,
                  ),
                );
              },
            );
          },
          list: readQuranState.surahs,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    if (_searchQuery.isEmpty) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64.sp,
            color: context.colors.onPrimary.withOpacity(0.5),
          ),
          Gap(16.h),
          Text(
            'لا توجد نتائج',
            style: context.titleMedium?.copyWith(
              color: context.colors.onPrimary.withOpacity(0.7),
            ),
          ),
          Gap(8.h),
          Text(
            'جرب البحث بكلمات مختلفة',
            style: context.bodySmall?.copyWith(
              color: context.colors.onPrimary.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemDownloaded extends StatefulWidget {
  const _ItemDownloaded({
    required this.boxController,
    super.key,
    this.data,
    this.indexSurah,
    this.searchQuery = '',
  });
  final NewSurahModel? data;
  final int? indexSurah;
  final BoxController boxController;
  final String searchQuery;
  @override
  State<_ItemDownloaded> createState() => _ItemDownloadedState();
}

class _ItemDownloadedState extends State<_ItemDownloaded> {
  int? current;

  String _highlightText(String text, String query) {
    if (query.isEmpty) return text;

    final normalizedText = text.toLowerCase();
    final normalizedQuery = query.toLowerCase();

    if (!normalizedText.contains(normalizedQuery)) return text;

    final index = normalizedText.indexOf(normalizedQuery);
    final before = text.substring(0, index);
    final match = text.substring(index, index + query.length);
    final after = text.substring(index + query.length);

    return '$before$match$after';
  }

  Widget _buildHighlightedText(String text, String query) {
    if (query.isEmpty) {
      return Text(
        text,
        style: titleSmall(context).copyWith(
          fontSize: 16.sp,
          color: !_isCurrentPlaying() ? null : context.primaryColor,
        ),
      );
    }

    final normalizedText = text.toLowerCase();
    final normalizedQuery = query.toLowerCase();

    if (!normalizedText.contains(normalizedQuery)) {
      return Text(
        text,
        style: titleSmall(context).copyWith(
          fontSize: 16.sp,
          color: !_isCurrentPlaying() ? null : context.primaryColor,
        ),
      );
    }

    final index = normalizedText.indexOf(normalizedQuery);
    final before = text.substring(0, index);
    final match = text.substring(index, index + query.length);
    final after = text.substring(index + query.length);

    return RichText(
      text: TextSpan(
        style: titleSmall(context).copyWith(
          fontSize: 16.sp,
          color: !_isCurrentPlaying() ? null : context.primaryColor,
        ),
        children: [
          TextSpan(text: before),
          TextSpan(
            text: match,
            style: TextStyle(
              backgroundColor: context.primaryColor.withOpacity(0.3),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: after),
        ],
      ),
    );
  }

  bool _isCurrentPlaying() {
    return context.read<QuranAudioBloc>().state.currentAudioData?.indexSurah ==
        widget.indexSurah;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranAudioBloc, QuranAudioState>(
      builder: (context, state) {
        final currentPlaying = _isCurrentPlaying();

        return FilledButtonWidget(
          onPressed: () {
            final updateCurrent = state.currentAudioData?.copyWith(
              countSurahVerse: widget.data!.ayahCount.toString(),
              nameSurah: widget.data!.nameAr,
              indexSurah: widget.indexSurah,
            );
            //save
            context.read<QuranAudioBloc>().add(
                  ChangeCurrentAudioDataEvent(
                    currentAudioData: updateCurrent!,
                    reInitialize: false,
                  ),
                );

            context.read<QuranAudioBloc>().add(
                  SeekToAudioPlayerSourceEvent(
                    index: widget.indexSurah!,
                  ),
                );

            widget.boxController.openBox();
          },
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          borderRadius: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildHighlightedText(
                        widget.data?.nameAr ?? '',
                        widget.searchQuery,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      '(${widget.data?.ayahCount})',
                      style: titleSmall(context).copyWith(
                        color: !currentPlaying ? null : context.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<DownloadQuranAudioBloc, DownloadQuranAudioState>(
                builder: (context, stateDownload) {
                  return PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<void>(
                          onTap: () async {
                            final result =
                                await showDeleteConfirmationDialog<bool>(
                              context,
                              title: 'تحميل السورة',
                              message: 'هل تريد تحميل السورة؟',
                              icon: Icon(
                                Icons.download,
                                color: context.primaryColor,
                              ),
                            );
                            if ((result ?? false) == true) {
                              final surahs = state.surahInfoData;

                              final updateCurrent = CurrentQuranAudioModel(
                                countSurahVerse:
                                    state.currentAudioData!.countSurahVerse,
                                imageReader:
                                    state.currentAudioData!.imageReader,
                                nameReader: state.currentAudioData!.nameReader,
                                nameSurah: surahs[widget.indexSurah!].surah,
                                identifier: state.currentAudioData!.identifier,
                                indexSurah: widget.indexSurah! + 1,
                              );
                              if (context.mounted) {
                                context.read<DownloadQuranAudioBloc>().add(
                                      StartDownloadQuranAudioEvent(
                                        currentAudioData: updateCurrent,
                                      ),
                                    );
                              }
                            }
                          },
                          child: Text(
                            'تحميل السورة',
                            style: context.bodyMedium,
                          ),
                        ),
                      ];
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
