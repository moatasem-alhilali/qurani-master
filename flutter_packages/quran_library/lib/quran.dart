import 'dart:async' show Completer, StreamSubscription, Timer;
import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:developer' show log;
import 'dart:math' as math show max, min;
import 'dart:ui';

// import 'dart:ui';

import 'package:arabic_justified_text/arabic_justified_text.dart';
import 'package:archive/archive.dart' show GZipDecoder, ZipDecoder;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scale_kit/flutter_scale_kit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:preload_page_view/preload_page_view.dart'
    hide PageScrollPhysics, PageMetrics;

import 'src/audio/audio.dart';
import 'src/core/platform/io_helpers.dart';
import 'src/core/utils/app_colors.dart';
import 'src/core/utils/ui_helper.dart';
import 'src/core/widgets/download_button_widget.dart';
import 'src/core/widgets/header_dialog_widget.dart';
import 'src/quran/core/helpers/responsive.dart';
import 'src/service/connectivity_service.dart';
import 'src/service/gzip_json_asset_service.dart';
import 'src/service/internet_connection_controller.dart';
import 'src/tafsir/tafsir.dart';

part 'src/core/theme/quran_library_theme.dart';
part 'src/core/utils/assets_path.dart';
part 'src/core/utils/toast_utils.dart';
part 'src/core/widgets/patched_preload_page_view.dart';
part 'src/flutter_quran_utils.dart';
part 'src/pages/get_single_ayah.dart';
part 'src/pages/quran_library_screen.dart';
part 'src/pages/quran_pages_screen.dart';
part 'src/pages/surah_display_screen.dart';
part 'src/quran/core/extensions/context_extensions.dart';
part 'src/quran/core/extensions/convert_arabic_to_english_numbers_extension.dart';
part 'src/quran/core/extensions/convert_number_extension.dart';
part 'src/quran/core/extensions/font_size_extension.dart';
part 'src/quran/core/extensions/fonts_extension.dart';
part 'src/quran/core/extensions/sajda_extension.dart';
part 'src/quran/core/extensions/string_extensions.dart';
part 'src/quran/core/extensions/surah_info_extension.dart';
part 'src/quran/core/extensions/text_span_extension.dart';
part 'src/quran/core/helpers/page_font_size.dart';
part 'src/quran/core/services/quran_fonts_service.dart';
part 'src/quran/core/services/sura_json_files_service.dart';
part 'src/quran/core/services/word_audio_service.dart';
part 'src/quran/core/services/zip_download_service.dart';
part 'src/quran/core/utils/storage_constants.dart';
part 'src/quran/core/utils/tajweed_rules_list.dart';
part 'src/quran/data/models/auto_scroll_stop_condition.dart';
part 'src/quran/data/models/ayah_model.dart';
part 'src/quran/data/models/display_mode.dart';
part 'src/quran/data/models/quran_constants.dart';
part 'src/quran/data/models/quran_fonts_models/download_fonts_dialog_style.dart';
part 'src/quran/data/models/quran_fonts_models/sajda_model.dart';
part 'src/quran/data/models/quran_page.dart';
part 'src/quran/data/models/quran_recitation.dart';
part 'src/quran/data/models/styles_models/auto_scroll_style.dart';
part 'src/quran/data/models/styles_models/ayah_menu_style.dart';
part 'src/quran/data/models/styles_models/ayah_tafsir_inline_style.dart';
part 'src/quran/data/models/styles_models/banner_style.dart';
part 'src/quran/data/models/styles_models/basmala_style.dart';
part 'src/quran/data/models/styles_models/bookmark.dart';
part 'src/quran/data/models/styles_models/bookmarks_tab_style.dart';
part 'src/quran/data/models/styles_models/display_mode_bar_style.dart';
part 'src/quran/data/models/styles_models/index_tab_style.dart';
part 'src/quran/data/models/styles_models/quran_tafsir_side_style.dart';
part 'src/quran/data/models/styles_models/quran_top_bar_style.dart';
part 'src/quran/data/models/styles_models/search_tab_style.dart';
part 'src/quran/data/models/styles_models/snackbar_style.dart';
part 'src/quran/data/models/styles_models/surah_info_style.dart';
part 'src/quran/data/models/styles_models/surah_name_style.dart';
part 'src/quran/data/models/styles_models/tajweed_menu_style.dart';
part 'src/quran/data/models/styles_models/top_bottom_quran_style.dart';
part 'src/quran/data/models/styles_models/word_info_bottom_sheet_style.dart';
part 'src/quran/data/models/surah_names_model.dart';
part 'src/quran/data/models/word_info_models.dart';
part 'src/quran/data/qpc_v4/qpc_hafs_word_by_word_assets_loader.dart';
part 'src/quran/data/qpc_v4/qpc_v4_assets_loader.dart';
part 'src/quran/data/qpc_v4/qpc_v4_models.dart';
part 'src/quran/data/qpc_v4/qpc_v4_page_renderer.dart';
part 'src/quran/data/repositories/quran_repository.dart';
part 'src/quran/data/repositories/word_info_repository.dart';
part 'src/quran/presentation/controllers/auto_scroll/auto_scroll_ctrl.dart';
part 'src/quran/presentation/controllers/auto_scroll/auto_scroll_state.dart';
part 'src/quran/presentation/controllers/bookmark/bookmarks_ctrl.dart';
part 'src/quran/presentation/controllers/quran/quran_ctrl.dart';
part 'src/quran/presentation/controllers/quran/quran_getters.dart';
part 'src/quran/presentation/controllers/quran/quran_state.dart';
part 'src/quran/presentation/controllers/surah/surah_ctrl.dart';
part 'src/quran/presentation/controllers/word_info/word_info_ctrl.dart';
part 'src/quran/presentation/widgets/auto_scroll/auto_scroll_settings_widget.dart';
part 'src/quran/presentation/widgets/auto_scroll/auto_scroll_speed_slider.dart';
part 'src/quran/presentation/widgets/ayah_menu_dialog.dart';
part 'src/quran/presentation/widgets/bsmallah_widget.dart';
part 'src/quran/presentation/widgets/display_mode_bar.dart';
part 'src/quran/presentation/widgets/display_modes/auto_scroll_page_view.dart';
part 'src/quran/presentation/widgets/display_modes/ayah_with_tafsir_inline.dart';
part 'src/quran/presentation/widgets/display_modes/dual_page_view.dart';
part 'src/quran/presentation/widgets/display_modes/quran_with_tafsir_side.dart';
part 'src/quran/presentation/widgets/display_modes/single_scrollable_page.dart';
part 'src/quran/presentation/widgets/download_fonts_page/custom_span.dart';
part 'src/quran/presentation/widgets/download_fonts_page/page_build.dart';
part 'src/quran/presentation/widgets/download_fonts_page/qpc_v4_flowing_text.dart';
part 'src/quran/presentation/widgets/download_fonts_page/quran_fonts_page.dart';
part 'src/quran/presentation/widgets/download_fonts_page/rich_text_build.dart';
part 'src/quran/presentation/widgets/fonts_download_dialog.dart';
part 'src/quran/presentation/widgets/fonts_download_widget.dart';
part 'src/quran/presentation/widgets/jumping_between_pages_widget.dart';
part 'src/quran/presentation/widgets/page_view_build.dart';
part 'src/quran/presentation/widgets/surah_header_widget.dart';
part 'src/quran/presentation/widgets/surah_page/surah_page_view_build.dart';
part 'src/quran/presentation/widgets/tabs/bookmark_tab_widget.dart';
part 'src/quran/presentation/widgets/tabs/index_tab_widget.dart';
part 'src/quran/presentation/widgets/tabs/quran_or_ten_recitations_tab_bar.dart';
part 'src/quran/presentation/widgets/tabs/quran_top_bar.dart';
part 'src/quran/presentation/widgets/tabs/search_tab_widget.dart';
part 'src/quran/presentation/widgets/tajweed_menu_widget.dart';
part 'src/quran/presentation/widgets/top_bottom_widget/build_bottom_section.dart';
part 'src/quran/presentation/widgets/top_bottom_widget/build_top_section.dart';
part 'src/quran/presentation/widgets/top_bottom_widget/top_and_bottom_widget.dart';
part 'src/quran/presentation/widgets/word_info/marked_content_span.dart';
part 'src/quran/presentation/widgets/word_info/tap_long_press_recognizer.dart';
part 'src/quran/presentation/widgets/word_info/word_info_bottom_sheet.dart';

/// A comprehensive library for displaying the Holy Quran in Flutter applications.
///
/// This library provides a set of widgets, controllers, and data models to facilitate
/// the integration of Quranic text, tafsir (exegesis), and various display styles
/// into Flutter projects. It aims to offer a highly customizable and performant
/// solution for Quranic applications.
///
/// The core components of this library include:
/// - **Data Models**: Representing Ayahs, Surahs, Quran pages, and Tafsir data.
/// - **Controllers**: Managing the state and logic for Quran display, search, and bookmarking.
/// - **Widgets**: Reusable UI components for rendering Quranic text, surah headers, and interactive elements.
/// - **Utilities & Extensions**: Helper functions and Dart extensions for common tasks like number conversion, text normalization, and asset management.
///
/// This file (`quran.dart`) serves as the main entry point for the library, parting
/// all necessary components and defining the `part` directives for modular organization.
///
/// To use this library, import `package:quran_library/quran_library.dart` and utilize
/// the provided classes and functions. Ensure that all required assets (fonts, JSONs, DB) are correctly configured in `pubspec.yaml`.
