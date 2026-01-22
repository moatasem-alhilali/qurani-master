import 'dart:async' show Completer, Timer;
import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:developer' show log;
import 'dart:io' show File, Platform, Directory;
import 'dart:isolate';
import 'dart:math' as math show max;

import 'package:arabic_justified_text/arabic_justified_text.dart';
import 'package:archive/archive.dart' show ZipDecoder;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scale_kit/flutter_scale_kit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:path_provider/path_provider.dart';

import 'src/audio/audio.dart';
import 'src/core/utils/app_colors.dart';
import 'src/core/utils/ui_helper.dart';
import 'src/core/widgets/header_dialog_widget.dart';
import 'src/quran/core/helpers/responsive.dart';
import 'src/service/connectivity_service.dart';
import 'src/service/internet_connection_controller.dart';
import 'src/tafsir/tafsir.dart';

part 'src/core/theme/quran_library_theme.dart';
part 'src/core/utils/assets_path.dart';
part 'src/core/utils/toast_utils.dart';
part 'src/flutter_quran_utils.dart';
part 'src/pages/get_single_ayah.dart';
part 'src/pages/quran_library_screen.dart';
part 'src/pages/quran_pages_screen.dart';
part 'src/pages/surah_display_screen.dart';
part 'src/quran/core/extensions/context_extensions.dart';
part 'src/quran/core/extensions/convert_arabic_to_english_numbers_extension.dart';
part 'src/quran/core/extensions/convert_number_extension.dart';
part 'src/quran/core/extensions/font_size_extension.dart';
part 'src/quran/core/extensions/fonts_download_widget.dart';
part 'src/quran/core/extensions/fonts_extension.dart';
part 'src/quran/core/extensions/sajda_extension.dart';
part 'src/quran/core/extensions/string_extensions.dart';
part 'src/quran/core/extensions/surah_info_extension.dart';
part 'src/quran/core/extensions/text_span_extension.dart';
part 'src/quran/core/helpers/page_font_size.dart';
part 'src/quran/core/utils/storage_constants.dart';
part 'src/quran/core/utils/tajweed_rules_list.dart';
part 'src/quran/data/models/ayah_model.dart';
part 'src/quran/data/models/quran_constants.dart';
part 'src/quran/data/models/quran_fonts_models/download_fonts_dialog_style.dart';
part 'src/quran/data/models/quran_fonts_models/sajda_model.dart';
part 'src/quran/data/models/quran_page.dart';
part 'src/quran/data/models/quran_recitation.dart';
part 'src/quran/data/models/styles_models/ayah_menu_style.dart';
part 'src/quran/data/models/styles_models/banner_style.dart';
part 'src/quran/data/models/styles_models/basmala_style.dart';
part 'src/quran/data/models/styles_models/bookmark.dart';
part 'src/quran/data/models/styles_models/bookmarks_tab_style.dart';
part 'src/quran/data/models/styles_models/index_tab_style.dart';
part 'src/quran/data/models/styles_models/quran_top_bar_style.dart';
part 'src/quran/data/models/styles_models/search_tab_style.dart';
part 'src/quran/data/models/styles_models/snackbar_style.dart';
part 'src/quran/data/models/styles_models/surah_info_style.dart';
part 'src/quran/data/models/styles_models/surah_name_style.dart';
part 'src/quran/data/models/styles_models/tajweed_menu_style.dart';
part 'src/quran/data/models/styles_models/top_bottom_quran_style.dart';
part 'src/quran/data/models/surah_names_model.dart';
part 'src/quran/data/qpc_v4/qpc_v4_assets_loader.dart';
part 'src/quran/data/qpc_v4/qpc_v4_models.dart';
part 'src/quran/data/qpc_v4/qpc_v4_page_renderer.dart';
part 'src/quran/data/repositories/quran_repository.dart';
part 'src/quran/presentation/controllers/bookmark/bookmarks_ctrl.dart';
part 'src/quran/presentation/controllers/quran/quran_ctrl.dart';
part 'src/quran/presentation/controllers/quran/quran_getters.dart';
part 'src/quran/presentation/controllers/quran/quran_state.dart';
part 'src/quran/presentation/controllers/surah/surah_ctrl.dart';
part 'src/quran/presentation/widgets/ayah_menu_dialog.dart';
part 'src/quran/presentation/widgets/bsmallah_widget.dart';
part 'src/quran/presentation/widgets/default_fonts_page/default_first_two_surahs.dart';
part 'src/quran/presentation/widgets/default_fonts_page/default_fonts.dart';
part 'src/quran/presentation/widgets/default_fonts_page/default_fonts_page.dart';
part 'src/quran/presentation/widgets/default_fonts_page/default_fonts_page_build.dart';
part 'src/quran/presentation/widgets/default_fonts_page/default_other_surahs.dart';
part 'src/quran/presentation/widgets/download_fonts_page/custom_span.dart';
part 'src/quran/presentation/widgets/download_fonts_page/page_build.dart';
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
part 'src/quran/presentation/widgets/tabs/quran_top_bar.dart';
part 'src/quran/presentation/widgets/tabs/search_tab_widget.dart';
part 'src/quran/presentation/widgets/tajweed_menu_widget.dart';
part 'src/quran/presentation/widgets/text_scale_page/text_scale_page.dart';
part 'src/quran/presentation/widgets/text_scale_page/text_scale_rich_text_build.dart';
part 'src/quran/presentation/widgets/top_bottom_widget/build_bottom_section.dart';
part 'src/quran/presentation/widgets/top_bottom_widget/build_top_section.dart';
part 'src/quran/presentation/widgets/top_bottom_widget/top_and_bottom_widget.dart';

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
