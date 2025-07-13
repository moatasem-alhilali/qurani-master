/*
© 2023, Hamed Shirvanie. All rights reserved.
Im Hamed Shirvanie, i build and defines this plugin in 5/29/23
LICENSE: https://github.com/shirvanie/flutter_sliding_box/blob/master/LICENSE
*/

import 'package:flutter/material.dart';

class SlidingBox extends StatefulWidget {
  SlidingBox({
    super.key,
    this.controller,
    this.width,
    this.minHeight = 200,
    this.maxHeight = 400,
    this.color = Colors.white,
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    ),
    this.style = BoxStyle.none,
    this.body,
    this.bodyBuilder,
    this.physics = const BouncingScrollPhysics(),
    this.draggable = true,
    this.draggableIcon = Icons.remove_rounded,
    this.draggableIconColor = const Color(0xff9a9a9a),
    this.draggableIconVisible = true,
    this.draggableIconBackColor = const Color(0x22777777),
    this.collapsed = false,
    this.collapsedBody,
    this.animationCurve = Curves.fastOutSlowIn,
    this.animationDuration = const Duration(milliseconds: 100),
    this.backdrop,
    this.onBoxSlide,
    this.onBoxClose,
    this.onBoxOpen,
    this.onBoxHide,
    this.onBoxShow,
    this.onSearchBoxHide,
    this.onSearchBoxShow,
  })  : assert(
          backdrop?.appBar?.leading == null || controller != null,
          'controller must not be null',
        ),
        assert(
          backdrop?.appBar?.searchBox == null || controller != null,
          'controller must not be null',
        );

  /// It can be used to control the state of sliding box and search box.
  final BoxController? controller;

  /// The [width] of the sliding box.
  final double? width;

  /// The height of the sliding box when fully [collapsed].
  final double? minHeight;

  /// The height of the sliding box when fully opened.
  final double? maxHeight;

  /// The [color] to fill the background of the sliding box.
  final Color? color;

  /// The corners of the sliding box are rounded by this.
  final BorderRadius? borderRadius;

  /// The styles behind of the sliding box that includes shadow, sheet, none.
  final BoxStyle? style;

  /// A widget that slides from [minHeight] to [maxHeight] and is placed on the
  /// backdrop.
  final Widget? body;

  /// Provides a ScrollController to attach to a scrollable widget in the box
  /// and current box position. If [body] and [bodyBuilder] are both non-null,
  /// [body] will be used.
  final Widget Function(
    ScrollController scrollController,
    double boxPosition,
  )? bodyBuilder;

  /// Gets a ScrollPhysic, the [physics] determines how the scroll view
  /// continues to animate after the user stops dragging the scroll view.
  final ScrollPhysics? physics;

  /// Allows toggling of draggability of the sliding box. if set this to false,
  /// the sliding box cannot be dragged up or down.
  final bool? draggable;

  /// A Icon Widget that is placed in top of the box.
  /// Gets a IconData.
  final IconData? draggableIcon;

  /// The color of the [draggableIcon].
  /// the position of the icon is top of the box.
  final Color? draggableIconColor;

  /// If set to false, the [draggableIcon] hides. Use the controller to
  /// open and close sliding box by taps.
  final bool? draggableIconVisible;

  /// The color to fill the background of the [draggableIcon] icon.
  /// the position of the icon is top of the box.
  final Color? draggableIconBackColor;

  /// If set to true, the state of the box is [collapsed].
  final bool? collapsed;

  /// The Widget displayed overtop the box when [collapsed].
  /// This fades out as the sliding box is opened.
  final Widget? collapsedBody;

  /// The [animationCurve] defines the easier behavior of the box animation.
  final Curve? animationCurve;

  /// The [animationDuration] defines the time for the box animation to
  /// complete.
  final Duration? animationDuration;

  /// A Widget that is placed under the box, the value should be filled with
  /// the [Backdrop] object.
  final Backdrop? backdrop;

  /// This callback is called when the sliding box slides around with position
  /// of the box. the position is a double value between 0.0 and 1.0,
  /// where 0.0 is fully collapsed and 1.0 is fully opened.
  final ValueChanged<double>? onBoxSlide;

  /// This callback is called when the sliding box is fully closed.
  final VoidCallback? onBoxClose;

  /// This callback is called when the sliding box is fully opened.
  final VoidCallback? onBoxOpen;

  /// This callback is called when the sliding box is invisible.
  final VoidCallback? onBoxHide;

  /// This callback is called when the sliding box is visible.
  final VoidCallback? onBoxShow;

  /// This callback is called when the search box is invisible.
  final VoidCallback? onSearchBoxHide;

  /// This callback is called when the search box is visible.
  final VoidCallback? onSearchBoxShow;

  @override
  State<SlidingBox> createState() => _SlidingBoxState();
}

class _SlidingBoxState extends State<SlidingBox> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _opacityAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _fadeAnimationReverse;
  late Animation<double> _opacityAnimation;
  late Animation<double> _opacityAnimationReverse;
  late ScrollController _scrollController;
  late double _boxWidth;
  late double _backdropWidth;
  late Widget _searchBody;
  bool _isBoxVisible = true;
  bool _isBoxOpen = true;
  bool _isBoxAnimating = false;
  bool _isSearchBoxVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      reverseDuration: widget.animationDuration,
      value: widget.collapsed == true ? 0.0 : 1.0,
    )..addListener(() {
        if (widget.onBoxSlide != null) {
          widget.onBoxSlide!.call(_animationController.value);
        }
        if (widget.onBoxClose != null &&
            _isBoxOpen &&
            _animationController.value == 0.0) {
          widget.onBoxClose!.call();
        }
        if (widget.onBoxOpen != null &&
            !_isBoxOpen &&
            _animationController.value == 1.0) {
          widget.onBoxOpen!.call();
        }
      });
    _opacityAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      value: 0,
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve!,
        reverseCurve: widget.animationCurve,
      ),
    );
    _fadeAnimationReverse = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve!,
        reverseCurve: widget.animationCurve,
      ),
    );
    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _opacityAnimationController,
        curve: widget.animationCurve!,
        reverseCurve: widget.animationCurve,
      ),
    );
    _opacityAnimationReverse = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _opacityAnimationController,
        curve: widget.animationCurve!,
        reverseCurve: widget.animationCurve,
      ),
    );
    _scrollController = ScrollController();
    _isBoxOpen = !widget.collapsed!;
    _searchBody = (widget.backdrop?.appBar?.searchBox?.body != null)
        ? widget.backdrop!.appBar!.searchBox!.body!
        : const SizedBox.shrink();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _opacityAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller != null) widget.controller!._addState(this);
    _boxWidth = (widget.width != null)
        ? widget.width!
        : MediaQuery.of(context).size.width;
    _backdropWidth = (widget.backdrop?.width != null)
        ? widget.backdrop!.width!
        : MediaQuery.of(context).size.width;
    return PopScope(
      canPop: !_isSearchBoxVisible,
      onPopInvoked: (_) {
        /// handle app back button when [BackdropAppBar.searchBox] shows.
        if (_isSearchBoxVisible) {
          widget.controller!.hideSearchBox();
        }
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (widget.backdrop != null) _backdrop(),
          if (_isBoxVisible == true) _body(),
        ],
      ),
    );
  }

  /// Returns a Widget that placed in [Backdrop.body].
  Widget _backdrop() {
    return _gestureHandler(
      dragUpdate: widget.draggable!,
      dragEnd: widget.draggable!,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, child) {
          return Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: _backdropWidth,
              height: MediaQuery.of(context).size.height,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backdrop?.backgroundGradient == null
                      ? widget.backdrop?.color
                      : null,
                  gradient: widget.backdrop?.backgroundGradient,
                ),
                child: Stack(
                  children: [
                    Container(
                      transform: widget.backdrop!.moving == true
                          ? Matrix4.translationValues(
                              0,
                              -((_animationController.value *
                                      ((widget.maxHeight! -
                                              MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom) -
                                          widget.minHeight!)) *
                                  0.2),
                              0,
                            )
                          : null,
                      margin: EdgeInsets.only(
                        bottom: _isBoxVisible
                            ? widget.minHeight! > 0
                                ? widget.minHeight! - 25
                                : 0
                            : 0,
                      ),
                      child: widget.backdrop!.fading == true
                          ? Opacity(
                              opacity: 1.0 - _animationController.value,
                              child: widget.backdrop!.body,
                            )
                          : widget.backdrop!.body,
                    ),
                    if (widget.backdrop?.overlay == true)
                      GestureDetector(
                        onTap: _onGestureTap,
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (_, child) {
                            if (_animationController.value > 0.0) {
                              return Opacity(
                                opacity: _animationController.value,
                                child: Container(
                                  color: Colors.black.withAlpha(
                                    (widget.backdrop!.overlayOpacity! * 255)
                                        .toInt(),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ),
                    if (widget.backdrop?.appBar != null)
                      SafeArea(
                        child: _isSearchBoxVisible
                            ? FadeTransition(
                                opacity: _opacityAnimation,
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 10, 0),
                                  width: _backdropWidth,
                                  height: 45,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: widget
                                        .backdrop?.appBar?.searchBox?.color,
                                    borderRadius: widget.backdrop?.appBar
                                        ?.searchBox?.borderRadius,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        width: 35,
                                        height: 35,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: widget.backdrop?.appBar
                                              ?.searchBox?.style?.color
                                              ?.withAlpha(25),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),
                                        child: IconButton(
                                          splashRadius: 30,
                                          color: widget.backdrop?.appBar
                                              ?.searchBox?.style?.color,
                                          splashColor: widget.backdrop?.appBar
                                              ?.searchBox?.style?.color,
                                          iconSize: 18,
                                          icon: widget.backdrop!.appBar!
                                              .searchBox!.leading!,
                                          onPressed: () {
                                            widget.controller!.hideSearchBox();
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          autofocus: true,
                                          controller: widget.backdrop?.appBar
                                              ?.searchBox?.controller,
                                          decoration: widget.backdrop?.appBar
                                              ?.searchBox?.inputDecoration,
                                          style: widget.backdrop?.appBar
                                              ?.searchBox?.style,
                                        ),
                                      ),
                                      Container(
                                        width: 25,
                                        height: 25,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: widget.backdrop?.appBar
                                              ?.searchBox?.style?.color
                                              ?.withAlpha(25),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          splashRadius: 30,
                                          color: widget.backdrop?.appBar
                                              ?.searchBox?.style?.color,
                                          splashColor: widget.backdrop?.appBar
                                              ?.searchBox?.style?.color,
                                          iconSize: 18,
                                          icon: Icon(
                                            Icons.close,
                                            color: widget.backdrop?.appBar
                                                ?.searchBox?.style?.color,
                                          ),
                                          onPressed: () {
                                            widget.backdrop?.appBar?.searchBox
                                                ?.controller.text = '';
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : FadeTransition(
                                opacity: _opacityAnimationReverse,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          if (_isBoxVisible &&
                                              widget.backdrop?.appBar
                                                      ?.leading !=
                                                  null)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                              ),
                                              child: GestureDetector(
                                                onTap: _onGestureTap,
                                                child: ValueListenableBuilder<
                                                    MenuIconValue>(
                                                  valueListenable:
                                                      widget.controller!,
                                                  builder: (_, value, __) {
                                                    return AnimatedSwitcher(
                                                      duration: const Duration(
                                                        milliseconds: 250,
                                                      ),
                                                      child: Icon(
                                                        key: ValueKey<bool>(
                                                          value.isOpenMenuIcon!,
                                                        ),
                                                        size: widget
                                                            .backdrop
                                                            ?.appBar
                                                            ?.leading
                                                            ?.size,
                                                        color: widget
                                                            .backdrop
                                                            ?.appBar
                                                            ?.leading
                                                            ?.color,
                                                        !value.isOpenMenuIcon!
                                                            ? widget
                                                                .backdrop
                                                                ?.appBar
                                                                ?.leading
                                                                ?.icon
                                                            : Icons.close,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          if (widget.backdrop?.appBar?.title !=
                                              null)
                                            widget.backdrop!.appBar!.title!,
                                        ],
                                      ),
                                      if (widget.backdrop?.appBar?.actions !=
                                          null)
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              Theme.of(context).useMaterial3
                                                  ? CrossAxisAlignment.center
                                                  : CrossAxisAlignment.stretch,
                                          children:
                                              widget.backdrop!.appBar!.actions!,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Returns a Widget that placed in [SlidingBox.body].
  Widget _body() {
    return _gestureHandler(
      dragUpdate: widget.draggable!,
      dragEnd: widget.draggable!,
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (_, child) {
            return Stack(
              children: <Widget>[
                if (widget.style == BoxStyle.sheet)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin:
                          EdgeInsets.only(top: _isSearchBoxVisible ? 55 : 0),
                      width: _boxWidth,
                      height: _animationController.value *
                              ((widget.maxHeight! -
                                      MediaQuery.of(context)
                                          .viewInsets
                                          .bottom) -
                                  widget.minHeight!) +
                          widget.minHeight! +
                          10,
                      child: Center(
                        child: Container(
                          width: _boxWidth - 50,
                          decoration: BoxDecoration(
                            color: widget.color?.withAlpha(
                              widget.minHeight! > 0
                                  ? 100
                                  : (_animationController.value * 100).toInt(),
                            ),
                            borderRadius: widget.borderRadius,
                          ),
                        ),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    // duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.only(top: _isSearchBoxVisible ? 65 : 0),
                    width: _boxWidth,
                    height: _animationController.value *
                            ((widget.maxHeight! -
                                    MediaQuery.of(context).viewInsets.bottom) -
                                widget.minHeight!) +
                        widget.minHeight!,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: widget.borderRadius!.topLeft,
                        topRight: widget.borderRadius!.topRight,
                        bottomLeft: Radius.circular(
                          (1.0 - _animationController.value) *
                              widget.borderRadius!.bottomLeft.y,
                        ),
                        bottomRight: Radius.circular(
                          (1.0 - _animationController.value) *
                              widget.borderRadius!.bottomLeft.y,
                        ),
                      ),
                      boxShadow: (widget.style == BoxStyle.shadow)
                          ? [
                              BoxShadow(
                                color: Colors.black.withAlpha(
                                  widget.minHeight! > 0
                                      ? 80
                                      : (_animationController.value * 80)
                                          .toInt(),
                                ),
                                spreadRadius: 7,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Container(
                      color: widget.color,
                      child: Stack(
                        children: [
                          if (widget.draggableIconVisible! && widget.draggable!)
                            GestureDetector(
                              onTap: _onGestureTap,
                              child: Container(
                                width: _boxWidth,
                                height: 30,
                                color: widget.draggableIconBackColor,
                                child: Transform(
                                  transform:
                                      Matrix4.translationValues(0, -15, 0),
                                  child: Icon(
                                    widget.draggableIcon,
                                    color: widget.draggableIconColor,
                                    size: 62,
                                  ),
                                ),
                              ),
                            ),
                          if (!_isSearchBoxVisible)
                            Container(
                              padding: widget.draggableIconVisible! &&
                                      widget.draggable!
                                  ? const EdgeInsets.only(top: 30)
                                  : null,
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                physics: (_isBoxOpen &&
                                        !_isSearchBoxVisible &&
                                        _animationController.value > 0.0)
                                    ? widget.physics!
                                    : const NeverScrollableScrollPhysics(),
                                child: widget.collapsedBody != null
                                    ? FadeTransition(
                                        opacity: _fadeAnimation,
                                        child: widget.body != null
                                            ? widget.body!
                                            : widget.bodyBuilder != null
                                                ? widget.bodyBuilder!(
                                                    _scrollController,
                                                    _boxPosition,
                                                  )
                                                : Container(),
                                      )
                                    : widget.body != null
                                        ? widget.body!
                                        : widget.bodyBuilder != null
                                            ? widget.bodyBuilder!(
                                                _scrollController,
                                                _boxPosition,
                                              )
                                            : Container(),
                              ),
                            ),
                          if (_isSearchBoxVisible)
                            Container(
                              margin: widget.draggableIconVisible! &&
                                      widget.draggable!
                                  ? const EdgeInsets.only(top: 30)
                                  : null,
                              color: widget.color,
                              child: FadeTransition(
                                opacity: _opacityAnimation,
                                child: _searchBody,
                              ),
                            ),
                          if (widget.collapsedBody != null &&
                              _animationController.value < 1.0)
                            Container(
                              padding: widget.draggableIconVisible! &&
                                      widget.draggable!
                                  ? const EdgeInsets.only(top: 30)
                                  : null,
                              child: FadeTransition(
                                opacity: _fadeAnimationReverse,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  color: widget.color,
                                  child: widget.collapsedBody,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Returns a gesture detector when user dragging on the box or backdrop.
  Widget _gestureHandler({
    required Widget child,
    bool dragUpdate = false,
    bool dragEnd = false,
    bool onTap = false,
  }) {
    return GestureDetector(
      onVerticalDragUpdate: dragUpdate
          ? (DragUpdateDetails details) => _onGestureUpdate(details.delta.dy)
          : null,
      onVerticalDragEnd: dragEnd
          ? (DragEndDetails details) => _onGestureEnd(details.velocity)
          : null,
      onTap: () => onTap ? _onGestureTap() : null,
      child: child,
    );
  }

  /// handles when user dragging the sliding box.
  void _onGestureUpdate(double dy) {
    if (_isBoxAnimating == true) return;
    if (_isSearchBoxVisible &&
        widget.backdrop?.appBar?.searchBox?.draggableBody == false) return;
    if (_isSearchBoxVisible) {
      _opacityAnimationController.reverse().then((_) {
        if (widget.controller != null) widget.controller!.hideSearchBox();
      });
    }
    _animationController.value -= dy /
        ((widget.maxHeight! - MediaQuery.of(context).viewInsets.bottom) -
            widget.minHeight!);
    if (widget.controller == null) return;
    if (_animationController.value == 1.0) {
      widget.controller!.openBox();
    } else if (_animationController.value == 0.0) {
      widget.controller!.closeBox();
    }
  }

  /// handles when user stops sliding.
  void _onGestureEnd(Velocity v) {
    if (_isBoxAnimating == true) return;
    if (_isSearchBoxVisible &&
        widget.backdrop?.appBar?.searchBox?.draggableBody == false) return;
    if (_isSearchBoxVisible) {
      _opacityAnimationController.reverse().then((_) {
        if (widget.controller != null) widget.controller!.hideSearchBox();
      });
    }
    _isBoxAnimating = true;
    if (v.pixelsPerSecond.dy > 0 &&
        v.pixelsPerSecond.dy >
            (widget.maxHeight! - MediaQuery.of(context).viewInsets.bottom)) {
      _animationController
          .animateTo(
            0,
            duration: widget.animationDuration,
            curve: widget.animationCurve!,
          )
          .then((_) => _isBoxAnimating = false)
          .then((_) {
        if (widget.controller != null) widget.controller!.closeBox();
      });
    } else if (v.pixelsPerSecond.dy < 0 &&
        v.pixelsPerSecond.dy <
            -(widget.maxHeight! - MediaQuery.of(context).viewInsets.bottom)) {
      _animationController
          .animateTo(
            1,
            duration: widget.animationDuration,
            curve: widget.animationCurve!,
          )
          .then((_) => _isBoxAnimating = false)
          .then((_) {
        if (widget.controller != null) widget.controller!.openBox();
      });
    } else {
      if (_animationController.value < 0.7) {
        _animationController
            .animateTo(
              0,
              duration: widget.animationDuration,
              curve: widget.animationCurve!,
            )
            .then((_) => _isBoxAnimating = false)
            .then((_) {
          if (widget.controller != null) widget.controller!.closeBox();
        });
      } else {
        _animationController
            .animateTo(
              1,
              duration: widget.animationDuration,
              curve: widget.animationCurve!,
            )
            .then((_) => _isBoxAnimating = false)
            .then((_) {
          if (widget.controller != null) widget.controller!.openBox();
        });
      }
    }
  }

  /// handles when user tap on sliding box.
  void _onGestureTap() {
    if (_isBoxAnimating == true) return;
    if (_isSearchBoxVisible &&
        widget.backdrop?.appBar?.searchBox?.draggableBody == false) return;
    widget.controller != null && widget.controller!.isBoxOpen
        ? widget.controller?.closeBox()
        : widget.controller?.openBox();
  }

  ///---------------------------------
  ///BoxController related functions
  ///---------------------------------

  /// Closes the sliding box with animation (i.e. to the SlidingBox.maxHeight).
  Future<void> _closeBox() async {
    if (!_isBoxVisible) return;
    return _animationController.fling(velocity: -1).then((_) {
      setState(() {
        _isBoxOpen = false;
      });
      if (_isSearchBoxVisible && widget.controller != null)
        widget.controller!.hideSearchBox();
    });
  }

  /// Opens the sliding box with animation (i.e. to the [SlidingBox.maxHeight]).
  Future<void> _openBox() async {
    if (!_isBoxVisible) return;
    return _animationController.fling().then((_) {
      setState(() {
        _isBoxOpen = true;
      });
    });
  }

  /// Hides [SlidingBox.body] (i.e. is invisible).
  Future<void> _hideBox() {
    return _animationController.fling(velocity: -1).then((_) {
      setState(() {
        _isBoxVisible = false;
      });
      if (widget.onBoxHide != null) {
        widget.onBoxHide!.call();
      }
      _closeSearchBox();
    });
  }

  /// Shows [SlidingBox.body] (i.e. is visible).
  Future<void> _showBox() {
    setState(() {
      _isBoxVisible = true;
    });
    if (widget.onBoxShow != null) {
      widget.onBoxShow!.call();
    }
    return _animationController.fling().then((x) {
      _closeSearchBox();
    });
  }

  /// Hides [BackdropAppBar.searchBox] (i.e. is invisible).
  Future<void> _hideSearchBox() async {
    if (widget.onSearchBoxHide != null) {
      widget.onSearchBoxHide!.call();
    }
    return _opacityAnimationController.fling(velocity: -1).then((_) {
      setState(() {
        _isSearchBoxVisible = false;
      });
    });
  }

  /// Shows [BackdropAppBar.searchBox] (i.e. is visible).
  Future<void> _showSearchBox() async {
    _openBox();
    setState(() {
      _isBoxVisible = true;
      _isSearchBoxVisible = true;
    });
    if (widget.onSearchBoxShow != null) {
      widget.onSearchBoxShow!.call();
    }
    return _opacityAnimationController.fling();
  }

  /// Closes [BackdropAppBar.searchBox].
  Future<void> _closeSearchBox() async {
    if (_isSearchBoxVisible) {
      _opacityAnimationController.reverse().then((_) {
        if (widget.controller != null) widget.controller!.hideSearchBox();
      });
    }
    if (widget.controller == null) return;
    if (_animationController.value == 1.0) {
      widget.controller!.openBox();
    } else if (_animationController.value == 0.0) {
      widget.controller!.closeBox();
    }
  }

  /// Sets current box [SlidingBox.body] with search result.
  Future<void> _setSearchBody(Widget child) async {
    setState(() {
      _searchBody = child;
    });
  }

  /// Sets current box position.
  Future<void> _setPosition(double value) {
    assert(0.0 <= value && value <= 1.0);
    return _animateBoxToPosition(value).then((_) {
      _boxPosition = value;
    });
  }

  /// Animate the box position to value - value must between 0.0 and 1.0.
  Future<void> _animateBoxToPosition(double value) {
    assert(0.0 <= value && value <= 1.0);
    _closeSearchBox();
    return _animationController.animateTo(
      value,
      duration: widget.animationDuration,
      curve: widget.animationCurve!,
    );
  }

  /// Sets current box position.
  set _boxPosition(double value) {
    assert(0.0 <= value && value <= 1.0);
    _animationController.value = value;
  }

  /// Gets current box position.
  double get _boxPosition => _animationController.value;

  /// Gets current box [SlidingBox.minHeight].
  double get _minHeight => widget.minHeight!;

  /// Gets current box [SlidingBox.maxHeight].
  double get _maxHeight => widget.maxHeight!;

  /// Gets current box [SlidingBox.width].
  double get _boxBodyWidth => _boxWidth;

  /// Gets current box [Backdrop.width].
  double get _backdropBodyWidth => _backdropWidth;
}

class MenuIconValue {
  const MenuIconValue({this.isOpenMenuIcon = false});

  /// Create a value with close icon menu state.
  factory MenuIconValue.closeMenu() {
    return const MenuIconValue();
  }

  /// Create a value with open icon menu state.
  factory MenuIconValue.openMenu() {
    return const MenuIconValue(isOpenMenuIcon: true);
  }

  final bool? isOpenMenuIcon;
}

class BoxController extends ValueNotifier<MenuIconValue> {
  BoxController() : super(const MenuIconValue());

  _SlidingBoxState? _boxState;

  void _addState(_SlidingBoxState boxState) {
    _boxState = boxState;
  }

  /// Determine if the [SlidingBox.controller] is attached to an instance of the
  /// [SlidingBox] (this property must be true before any other [BoxController]
  /// functions can be used).
  bool get isAttached => _boxState != null;

  /// Closes the sliding box with animation.
  /// (i.e. to the [SlidingBox.minHeight]).
  Future<void> closeBox() async {
    try {
      assert(isAttached, 'BoxController must be attached to a SlidingBox');
      value = MenuIconValue.openMenu();
      return _boxState!._closeBox().then((_) => notifyListeners());
    } catch (e) {
      return;
    }
  }

  /// Opens the sliding box with animation.
  /// (i.e. to the [SlidingBox.maxHeight]).
  Future<void> openBox() async {
    try {
      assert(isAttached, 'BoxController must be attached to a SlidingBox');
      value = MenuIconValue.closeMenu();
      return _boxState!._openBox().then((_) => notifyListeners());
    } catch (e) {
      return;
    }
  }

  /// Hides the sliding box (i.e. is invisible).
  Future<void> hideBox() async {
    try {
      assert(isAttached, 'BoxController must be attached to a SlidingBox');
      return _boxState!._hideBox();
    } catch (e) {
      return;
    }
  }

  /// Shows the sliding box (i.e. is visible).
  Future<void> showBox() async {
    try {
      assert(isAttached, 'BoxController must be attached to a SlidingBox');
      return _boxState!._showBox();
    } catch (e) {
      return;
    }
  }

  /// Hides the search box (i.e. is invisible).
  Future<void> hideSearchBox() async {
    try {
      assert(isAttached, 'BoxController must be attached to a SlidingBox');
      value = _boxState!._isBoxOpen
          ? MenuIconValue.closeMenu()
          : MenuIconValue.openMenu();
      return _boxState!._hideSearchBox().then((_) => notifyListeners());
    } catch (e) {
      return;
    }
  }

  /// Shows the search box (i.e. is visible).
  Future<void> showSearchBox() async {
    try {
      assert(isAttached, 'BoxController must be attached to a SlidingBox');
      return _boxState!._showSearchBox();
    } catch (e) {
      return;
    }
  }

  /// Sets the sliding box position with animation.
  /// (a value between 0.0 and 1.0).
  Future<void> setSearchBody({required Widget child}) async {
    try {
      assert(isAttached, 'BoxController must be attached to a SlidingBox');
      return _boxState!._setSearchBody(child);
    } catch (e) {
      return;
    }
  }

  Future<void> setPosition(double value) async {
    try {
      assert(isAttached, 'BoxController must be attached to a SlidingBox');
      assert(0.0 <= value && value <= 1.0);
      return _boxState!._setPosition(value);
    } catch (e) {
      return;
    }
  }

  /// Returns current box position (a value between 0.0 and 1.0).
  double get getPosition {
    assert(isAttached, 'BoxController must be attached to a SlidingBox');
    return _boxState!._boxPosition;
  }

  /// Returns whether or not the box is open.
  bool get isBoxOpen {
    assert(isAttached, 'BoxController must be attached to a SlidingBox');
    return _boxState!._isBoxOpen;
  }

  /// Returns whether or not the search box is visible.
  bool get isSearchBoxVisible {
    assert(isAttached, 'BoxController must be attached to a SlidingBox');
    return _boxState!._isSearchBoxVisible;
  }

  /// Returns whether or not the box is close or collapsed.
  bool get isBoxClosed {
    assert(isAttached, 'BoxController must be attached to a SlidingBox');
    return !_boxState!._isBoxOpen;
  }

  /// Returns whether or not the box is visible.
  bool get isBoxVisible {
    assert(isAttached, 'BoxController must be attached to a SlidingBox');
    return _boxState!._isBoxVisible;
  }

  /// Returns current box [SlidingBox.minHeight].
  double get minHeight {
    assert(isAttached, 'BoxController must be attached to a SlidingBox');
    return _boxState!._minHeight;
  }

  /// Returns current box [SlidingBox.maxHeight].
  double get maxHeight {
    assert(isAttached, 'BoxController must be attached to a SlidingBox');
    return _boxState!._maxHeight;
  }

  /// Returns current box [SlidingBox.width].
  double get boxWidth {
    assert(isAttached, 'BoxController must be attached to a SlidingBox');
    return _boxState!._boxBodyWidth;
  }

  /// Returns current backdrop box [Backdrop.width].
  double get backdropWidth {
    assert(isAttached, 'BoxController must be attached to a SlidingBox');
    return _boxState!._backdropBodyWidth;
  }
}

enum BoxStyle {
  none,
  shadow,
  sheet,
}

class Backdrop {
  const Backdrop({
    this.width,
    this.fading = false,
    this.moving = true,
    this.overlay = false,
    this.overlayOpacity = 0.5,
    this.color,
    this.backgroundGradient,
    this.appBar,
    this.body,
  }) : assert(
          overlayOpacity != null &&
              0.0 <= overlayOpacity &&
              overlayOpacity <= 1.0,
          'overlayOpacity double value must between 0.0 and 1.0',
        );

  /// The width of the backdrop [body].
  final double? width;

  /// If set to true, the backdrop [body] moving up when the sliding box opened.
  final bool? moving;

  /// If set to true, the backdrop [body] fades out when the sliding box opened.
  final bool? fading;

  /// If set to true, a dark layer displayed overtop the backdrop when
  /// sliding box opened.
  final bool? overlay;

  /// The value of the dark layer overtop the backdrop. a double value between
  /// 0.0 and 1.0.
  final double? overlayOpacity;

  /// The [color] to fill the background of the backdrop [body].
  final Color? color;

  /// The gradient color to fill the background of the backdrop. if [color] and
  /// [backgroundGradient] are both non-null, [color] will be used.
  final Gradient? backgroundGradient;

  /// An app bar to display at the top of the [SlidingBox.backdrop].
  final BackdropAppBar? appBar;

  /// A Widget that is placed in the [SlidingBox.backdrop] and behind
  /// the sliding box.
  final Widget? body;
}

class BackdropAppBar {
  const BackdropAppBar({
    this.title,
    this.leading,
    this.searchBox,
    this.actions,
  });

  /// A Widget that is placed on the topLeft of the [SlidingBox.backdrop].
  final Widget? title;

  /// A [Icon] Widget that is placed in left of the BackdropAppBar [title].
  final Icon? leading;

  /// An search box to display at the top of the [SlidingBox.backdrop].
  /// if non-null, an search Icon displayed on topRight of the backdrop.
  final SearchBox? searchBox;

  /// A list of Widgets that is placed on the topRight of the
  /// [SlidingBox.backdrop].
  final List<Widget>? actions;
}

class SearchBox {
  const SearchBox({
    required this.controller,
    this.leading = const Icon(Icons.arrow_back_ios_rounded),
    this.color = Colors.white,
    this.inputDecoration = const InputDecoration(
      border: InputBorder.none,
      hintText: 'Search...',
    ),
    this.borderRadius = const BorderRadius.all(
      Radius.circular(30),
    ),
    this.style = const TextStyle(
      color: Colors.black,
      fontSize: 18,
    ),
    this.body,
    this.draggableBody = true,
  });

  /// It can be used to control the state of search box text field.
  /// gets a [TextEditingController]
  final TextEditingController controller;

  /// A `Icon` Widget that is placed in left of the search box text field.
  final Icon? leading;

  /// The `color` to fill the background of the [SearchBox].
  final Color? color;

  /// The `decoration` to show around the search box text field.
  final InputDecoration? inputDecoration;

  /// The corners of the search box are rounded by this.
  final BorderRadius? borderRadius;

  /// The `style` to use for the text being edited.
  final TextStyle? style;

  /// A Widget that is placed in the sliding box and under the searching box.
  final Widget? body;

  /// Allows toggling of draggability of the sliding box. if set this to false,
  /// the sliding box cannot be dragged up or down when search box visible.
  /// if set this to true, search box invisible when dragging.
  final bool? draggableBody;
}

Future<T?> showSlidingBox<T>({
  required BuildContext context,
  required SlidingBox box,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = false,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TraversalEdgeBehavior? traversalEdgeBehavior,
}) {
  assert(debugCheckHasMaterialLocalizations(context));
  final themes = InheritedTheme.capture(
    from: context,
    to: Navigator.of(
      context,
      rootNavigator: useRootNavigator,
    ).context,
  );
  return Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
    DialogRoute<T>(
      context: context,
      builder: (context) => _slidingBoxModal(context, box),
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      settings: routeSettings,
      themes: themes,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior:
          traversalEdgeBehavior ?? TraversalEdgeBehavior.closedLoop,
    ),
  );
}

Widget _slidingBoxModal(BuildContext context, SlidingBox box) {
  final controller = box.controller ?? BoxController();
  Future.delayed(
    Duration.zero,
    () => controller.isAttached ? controller.openBox() : null,
  );
  return Material(
    type: MaterialType.transparency,
    child: SlidingBox(
      key: box.key,
      controller: controller,
      width: box.width,
      minHeight: 0,
      maxHeight: box.maxHeight,
      color: box.color,
      borderRadius: box.borderRadius,
      style: box.style,
      body: box.body,
      bodyBuilder: box.bodyBuilder,
      physics: box.physics,
      draggable: box.draggable,
      draggableIcon: box.draggableIcon,
      draggableIconColor: box.draggableIconColor,
      draggableIconVisible: box.draggableIconVisible,
      draggableIconBackColor: box.draggableIconBackColor,
      collapsed: true,
      collapsedBody: box.collapsedBody,
      animationCurve: box.animationCurve,
      animationDuration: box.animationDuration,
      onBoxClose: () {
        controller.dispose();
        Navigator.of(context).pop();
        box.onBoxClose?.call();
      },
      onBoxHide: box.onBoxHide,
      onBoxSlide: box.onBoxSlide,
      onBoxShow: box.onBoxShow,
      onBoxOpen: box.onBoxOpen,
    ),
  );
}
