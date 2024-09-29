import 'package:flutter/material.dart';

extension EListWidget on List<Widget> {
  List<Widget> addSpacing(double spacing, {required Axis direction}) {
    List<Widget> spacedWidgets = [];

    for (int i = 0; i < length; i++) {
      spacedWidgets.add(this[i]);

      if (i < length - 1) {
        spacedWidgets.add(
          direction == Axis.horizontal
              ? SizedBox(
                  width: spacing,
                )
              : SizedBox(
                  height: spacing,
                ),
        );
      }
    }

    return spacedWidgets;
  }
}
