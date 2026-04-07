import 'package:flutter/material.dart';

extension ResponsiveContext on BuildContext {
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;

  bool get isMobile => width < 768;
  bool get isTablet => width >= 768 && width < 1200;
  bool get isDesktop => width >= 1200;

  /// Returns a value based on the current screen size.
  T responsive<T>(T mobile, {T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}
