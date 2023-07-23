import 'package:flutter/material.dart';

class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final double breakpoint;
  final double widthPaddingFactor;
  final double innerPadding;
  final bool isScreenWrapper;

  ResponsivePadding({
    super.key,
    required this.child,
    this.breakpoint = 800,
    this.widthPaddingFactor = 0.02,
    this.innerPadding = 16.0,
    this.isScreenWrapper = false,
  }) {
    assert(
        widthPaddingFactor >= 0 && widthPaddingFactor <= 1, 'widthFactor must be between 0 and 1');
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration? backgroundDecoration;

    EdgeInsets? otherPadding;
    EdgeInsets? padding;

    return LayoutBuilder(builder: (context, constraints) {
      final double screenWidth = constraints.maxWidth;

      if (isScreenWrapper) {
        if (screenWidth < breakpoint) {
          otherPadding = const EdgeInsets.all(0);
        } else {
          otherPadding = EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.1);
          backgroundDecoration = BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.1),
                Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          );
        }
      } else {
        if (screenWidth < breakpoint) {
          padding = EdgeInsets.symmetric(horizontal: innerPadding);
        } else {
          padding = EdgeInsets.symmetric(horizontal: constraints.maxWidth * widthPaddingFactor);
        }
      }

      return Container(
        decoration: backgroundDecoration ?? const BoxDecoration(color: Colors.transparent),
        padding: otherPadding,
        child: Container(
          padding: isScreenWrapper
              ? EdgeInsets.symmetric(horizontal: innerPadding) //
              : padding,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: child,
        ),
      );
    });
  }
}
