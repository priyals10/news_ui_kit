import 'package:flutter/material.dart';

/// An adaptive layout wrapper that constrains the width of content on wide screens
/// (Web, Desktop, Tablet) but remains full-width on mobile.
/// It also handles centering and optional scroll/padding.
class WebConstrainedLayout extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;
  final bool scrollable;
  final ScrollController? scrollController;
  final double? height;
  final Color? backgroundColor;

  const WebConstrainedLayout({
    super.key,
    required this.child,
    this.maxWidth = 600,
    this.padding,
    this.scrollable = true,
    this.scrollController,
    this.height,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideScreen = screenWidth > 600;

    return Material(
      color: backgroundColor ?? Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: height ?? (scrollable ? null : double.infinity),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWideScreen ? maxWidth : screenWidth,
            ),
            child: Container(
              width: double.infinity,
              height: height ?? (scrollable ? null : double.infinity),
              padding: padding ?? EdgeInsets.zero,
              child: scrollable 
                ? SingleChildScrollView(
                    controller: scrollController,
                    child: child,
                  )
                : child,
            ),
          ),
        ),
      ),
    );
  }
}
