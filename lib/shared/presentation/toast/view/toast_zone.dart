import 'package:flutter/material.dart';

import '../controller/toast.dart';

class ToastZone extends StatelessWidget {
  final ToastBehavior behavior;
  final double minHeight;

  const ToastZone({
    super.key,
    this.behavior = ToastBehavior.pinnedDown,
    this.minHeight = 50,
  });

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.ltr,
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => _ToastHandlerWidget(
                behavior: behavior,
                minHeight: minHeight,
              ),
            ),
          ],
        ),
      );
}

class _ToastHandlerWidget extends StatefulWidget {
  final ToastBehavior behavior;
  final double minHeight;

  const _ToastHandlerWidget({
    Key? key,
    required this.behavior,
    this.minHeight = 50,
  }) : super(key: key);

  @override
  State<_ToastHandlerWidget> createState() => __ToastHandlerWidget();
}

class __ToastHandlerWidget extends State<_ToastHandlerWidget> with TickerProviderStateMixin {
  List<ToastData> toastQueue = [];
  bool isShowing = false;
  bool isCustomShowing = false;
  OverlayEntry? toastCustomEntry;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    Toast.initialize();
    _listenToastStream();
    _listenToastCustomNotifier();
    _initializeAnimation();
  }

  void _listenToastStream() {
    Toast.instance.toastStream.stream.listen((ToastData toastData) {
      if (!toastQueue.any((data) => data.message == toastData.message)) {
        toastQueue.add(toastData);
        if (!isShowing) {
          _showNextToast();
        }
      }
    });
  }

  void _listenToastCustomNotifier() {
    Toast.instance.toastCustomNotifier.addListener(() async {
      if (Toast.instance.toastCustomNotifier.value != null) {
        _showCustomToast(Toast.instance.toastCustomNotifier.value!);
      } else {
        if (isCustomShowing) {
          _animationController.reverse();
          await Future.delayed(const Duration(milliseconds: 500));
          toastCustomEntry?.remove();
          isCustomShowing = false;
        }
      }
    });
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _showNextToast() {
    if (toastQueue.isNotEmpty) {
      final toastData = toastQueue.removeAt(0);
      final behavior = toastData.behavior ?? widget.behavior;
      isShowing = true;

      final OverlayEntry toastEntry = OverlayEntry(
        builder: (BuildContext context) => Positioned(
          bottom: behavior == ToastBehavior.pinnedDown
              ? MediaQuery.of(context).viewInsets.bottom
              : behavior == ToastBehavior.floating
                  ? widget.minHeight + MediaQuery.of(context).viewInsets.bottom
                  : null,
          top: behavior == ToastBehavior.pinnedUp
              ? MediaQuery.of(context).padding.top + widget.minHeight
              : null,
          child: _ToastWidget(
            toastData: toastData,
            animation: _animation,
            behavior: behavior,
            toastMinHeight: widget.minHeight,
          ),
        ),
      );

      Overlay.of(context).insert(toastEntry);

      _animationController.forward();

      final duration = Duration(milliseconds: (toastData.duration.inMilliseconds) - 500);

      Future.delayed(duration).then((_) async {
        _animationController.reverse();
        await Future.delayed(const Duration(milliseconds: 500));
        toastEntry.remove();
        isShowing = false;
        if (toastQueue.isNotEmpty) {
          await Future.delayed(const Duration(milliseconds: 500));
          _showNextToast();
        }
      });
    }
  }

  void _showCustomToast(ToastCustomData toasCustomData) {
    if (!isCustomShowing) {
      isCustomShowing = true;

      toastCustomEntry = OverlayEntry(
        builder: (context) => SafeArea(
          child: Material(
            type: MaterialType.transparency,
            child: toasCustomData.activeFade
                ? FadeTransition(
                    opacity: _animation,
                    child: Stack(
                      alignment: toasCustomData.alignment,
                      children: [
                        toasCustomData.builder(context),
                      ],
                    ),
                  )
                : Stack(
                    alignment: toasCustomData.alignment,
                    children: [
                      toasCustomData.builder(context),
                    ],
                  ),
          ),
        ),
      );

      Overlay.of(context).insert(toastCustomEntry!);
      _animationController.forward();

      if (toasCustomData.duration != null) {
        Future.delayed(toasCustomData.duration!).then((_) async {
          _animationController.reverse();
          await Future.delayed(const Duration(milliseconds: 500));
          if (isCustomShowing) {
            toastCustomEntry?.remove();
            isCustomShowing = false;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    Toast.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}

class _ToastWidget extends StatefulWidget {
  final ToastData toastData;
  final double toastMinHeight;
  final Animation<double> animation;
  final ToastBehavior behavior;

  const _ToastWidget({
    Key? key,
    required this.toastData,
    required this.animation,
    this.toastMinHeight = 50,
    required this.behavior,
  }) : super(key: key);

  @override
  State<_ToastWidget> createState() => __ToastWidgetState();
}

class __ToastWidgetState extends State<_ToastWidget> {
  bool _isShowing = false;
  double toastHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      toastHeight = renderBox.size.height;
      if (!_isShowing) {
        setState(() {
          _isShowing = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.behavior) {
      case ToastBehavior.pinnedDown:
      case ToastBehavior.pinnedUp:
        return SafeArea(
          child: Opacity(
            opacity: _isShowing ? 1 : 0,
            child: AnimatedBuilder(
              animation: widget.animation,
              builder: (context, child) {
                final Offset offset;
                final double opacity;
                if (widget.behavior == ToastBehavior.pinnedDown) {
                  offset = Offset(0, toastHeight * (1 - widget.animation.value));
                  opacity = 1.0;
                } else if (widget.behavior == ToastBehavior.pinnedUp) {
                  offset = Offset(0, -toastHeight - toastHeight * (1 - widget.animation.value));
                  opacity = 1.0;
                } else {
                  offset = Offset.zero;
                  opacity = widget.animation.value;
                }
                return Opacity(
                  opacity: opacity,
                  child: Transform.translate(
                    offset: offset,
                    child: Material(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: widget.toastMinHeight,
                        ),
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        color: widget.toastData.backgroundColor
                                ?.withOpacity(widget.toastData.opacity) ??
                            Colors.black.withOpacity(widget.toastData.opacity),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                widget.toastData.message,
                                style: TextStyle(
                                  color: widget.toastData.textColor ?? Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      case ToastBehavior.floating:
        return Opacity(
          opacity: _isShowing ? 1 : 0,
          child: AnimatedBuilder(
            animation: widget.animation,
            builder: (context, child) {
              final Offset offset;
              final double opacity;
              if (widget.behavior == ToastBehavior.pinnedDown) {
                offset = Offset(0, toastHeight * (1 - widget.animation.value));
                opacity = 1.0;
              } else if (widget.behavior == ToastBehavior.pinnedUp) {
                offset = Offset(0, 1 * widget.animation.value);
                opacity = 1.0;
              } else {
                offset = Offset.zero;
                opacity = widget.animation.value;
              }
              return Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: offset,
                  child: Material(
                    color: Colors.transparent,
                    elevation: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              minHeight: widget.toastMinHeight,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: widget.toastData.backgroundColor
                                      ?.withOpacity(widget.toastData.opacity) ??
                                  Colors.black.withOpacity(widget.toastData.opacity),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(24),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text(
                              widget.toastData.message,
                              style: TextStyle(
                                color: widget.toastData.textColor ?? Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );

      default:
        return Container();
    }
  }
}
