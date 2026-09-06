import 'package:flutter/material.dart';

class TextHelpers {
  /// Get the current screen width
  ///
  /// 375 is a standard reference width (e.g., iPhone 11 Pro/X)
  ///
  /// default recomende: regular text
  /// recomended h1 perfectDesignSize = 28.0, minSize = 22.0 ,and maxsize = 40.0.
  /// recomended h2 perfectDesignSize = 22.0, minSize = 18.0 and maxsize = 32.0.
  /// recomended body perfectDesignSize = 16.0, minSize = 14.0 and maxsize = 22.0.
  static double responsiveFontSize(
    BuildContext context, {
    double scalefactor = 375,
    double perfectDesignSize = 16.0,
    double minSize = 12.0,
    double maxSize = 24.0,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;

    double scaleFactor = screenWidth / scalefactor;

    // Calculate responsive font size with a standard baseline of 16.0
    // The clamp method ensures the text doesn't get ridiculously small or large
    return (perfectDesignSize * scaleFactor).clamp(minSize, maxSize);
  }
}
