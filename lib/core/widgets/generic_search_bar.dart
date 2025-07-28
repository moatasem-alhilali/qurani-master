import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quran_app/core/extensions/colors_extension.dart';
import 'package:quran_app/core/widgets/icon_button_widget.dart';

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
    return SearchAnchor(
      builder: (context, controller) => IconButtonWidget(
        icon: Icon(
          widget.icon ?? Icons.search,
        ),
        onPressed: controller.openView,
        tooltip: widget.hintText ?? 'بحث',
        // backgroundColor: context.surfaceColor,
      ),
      searchController: searchController,
      viewLeading: IconButtonWidget(
        // size: 50.sp,
        icon: const FittedBox(
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            // size: 50.sp,
          ),
        ),
        onPressed: () {
          searchController.closeView('');
        },
        backgroundColor: context.surfaceColor,
      ),
      viewTrailing: [
        IconButtonWidget(
          icon: const FittedBox(
            child: Icon(Icons.close),
          ),
          onPressed: searchController.clear,
          backgroundColor: context.surfaceColor,
        ),
      ],
      viewBackgroundColor: context.scaffoldBackgroundColor,
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
