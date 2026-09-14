import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';

typedef AsyncSuggestionCallback<T> = Future<List<T>> Function(String query);
typedef SuggestionWidgetBuilder<T> = Widget Function(
  BuildContext context,
  T item,
);

class GenericSearchAnchorAsync<T> extends StatefulWidget {
  const GenericSearchAnchorAsync({
    required this.asyncSuggestions,
    required this.suggestionBuilder,
    required this.onSelected,
    super.key,
    this.hintText,
    this.barBackgroundColor,
    this.barElevation,
    this.width,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.icon,
  });

  final AsyncSuggestionCallback<T> asyncSuggestions;
  final SuggestionWidgetBuilder<T> suggestionBuilder;
  final void Function(T selected) onSelected;

  final String? hintText;
  final Color? barBackgroundColor;
  final double? barElevation;
  final double? width;
  final Duration debounceDuration;
  final IconData? icon;

  @override
  State<GenericSearchAnchorAsync<T>> createState() =>
      _GenericSearchAnchorAsyncState<T>();
}

class _GenericSearchAnchorAsyncState<T>
    extends State<GenericSearchAnchorAsync<T>> {
  String? _currentQuery;
  late Iterable<Widget> _lastOptions = <Widget>[];
  late final _Debounceable<Iterable<T>?, String> _debouncedSearch;
  final searchController = SearchController();
  @override
  void initState() {
    super.initState();
    _debouncedSearch =
        _debounce<Iterable<T>?, String>(_search, widget.debounceDuration);
  }

  Future<Iterable<T>?> _search(String query) async {
    _currentQuery = query;
    final Iterable<T> options = await widget.asyncSuggestions(_currentQuery!);

    if (_currentQuery != query) return null;
    _currentQuery = null;
    return options;
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    // أيقونات الشريط: مقاس صريح ولون من [AppSkin]، بلا مربّع مملوء خلفها.
    // كانت تُبنى بلا مقاس (فتأخذ الافتراضي الصغير) وبخلفية من اللوحة القديمة،
    // فتظهر أيقونة ضائعة داخل صندوق رمادي لا يتبع الثيم.
    Widget barIcon(HugeIconData icon, VoidCallback onPressed, String tooltip) {
      return IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(minWidth: 38.w, minHeight: 38.w),
        icon: AppIcon(icon, color: skin.accent, size: 20.sp),
      );
    }

    return SearchAnchor(
      builder: (context, controller) => widget.icon == null
          ? barIcon(AppIcons.search, controller.openView, 'بحث')
          : IconButton(
              onPressed: controller.openView,
              tooltip: widget.hintText ?? 'بحث',
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(minWidth: 38.w, minHeight: 38.w),
              icon: Icon(widget.icon, color: skin.accent, size: 20.sp),
            ),
      searchController: searchController,
      viewLeading: barIcon(
        AppIcons.back,
        () => searchController.closeView(''),
        'إغلاق البحث',
      ),
      viewTrailing: [
        barIcon(AppIcons.close, searchController.clear, 'مسح'),
        SizedBox(width: 4.w),
      ],
      viewHintText: widget.hintText ?? 'بحث',
      viewElevation: 0,
      viewSurfaceTintColor: Colors.transparent,
      dividerColor: skin.hairline,
      headerTextStyle: TextStyle(
        color: skin.ink,
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
      ),
      headerHintStyle: TextStyle(
        color: skin.inkSoft.withValues(alpha: 0.6),
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w500,
      ),
      viewBackgroundColor: skin.ground,
      suggestionsBuilder: (context, controller) async {
        final options = (await _debouncedSearch(controller.text))?.toList();
        if (options == null) return _lastOptions;
        _lastOptions = List<Widget>.generate(options.length, (int index) {
          final item = options[index];
          return InkWell(
            onTap: () {
              controller.closeView(item.toString());
              widget.onSelected(item);
            },
            child: widget.suggestionBuilder(context, item),
          );
        });
        return _lastOptions;
      },
    );
  }
}

// نفس منطق المثال الأصلي مع تغيير توقيت الديباونس حسب الباراميتر
typedef _Debounceable<S, T> = Future<S?> Function(T parameter);

_Debounceable<S, T> _debounce<S, T>(
  _Debounceable<S?, T> function,
  Duration debounceDuration,
) {
  _DebounceTimer? debounceTimer;
  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = _DebounceTimer(debounceDuration);
    try {
      await debounceTimer!.future;
    } on _CancelException {
      return null;
    }
    return function(parameter);
  };
}

class _DebounceTimer {
  _DebounceTimer(this.debounceDuration) {
    _timer = Timer(debounceDuration, _onComplete);
  }
  final Duration debounceDuration;
  late final Timer _timer;
  final Completer<void> _completer = Completer<void>();
  void _onComplete() => _completer.complete();
  Future<void> get future => _completer.future;
  bool get isCompleted => _completer.isCompleted;
  void cancel() {
    _timer.cancel();
    _completer.completeError(const _CancelException());
  }
}

class _CancelException implements Exception {
  const _CancelException();
}
