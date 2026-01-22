import 'package:flutter/material.dart';

class UiHelper {
  UiHelper._();

  /// Returns the current orientation based on the provided parameters.
  ///
  /// This method takes two parameters, [n1] and [n2], and determines the
  /// current orientation. The exact behavior and return type are dynamic
  /// and depend on the implementation details.
  ///
  /// - Parameters:
  ///   - n1: The first parameter used to determine the orientation.
  ///   - n2: The second parameter used to determine the orientation.
  ///
  /// - Returns: The current orientation based on the provided parameters.
  static dynamic currentOrientation(
      dynamic portrait, dynamic landscape, BuildContext context) {
    Orientation orientation = MediaQuery.orientationOf(context);
    return orientation == Orientation.portrait ? portrait : landscape;
  }
}
