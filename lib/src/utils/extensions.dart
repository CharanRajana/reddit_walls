import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension IntExtension on int {
  int get thumbnailIndex {
    if (this < 3) return this - 1;
    return 2;
  }

  String get format {
    if (this > 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this > 1000) {
      return '${(this / 1000).toStringAsFixed(0)}k';
    } else {
      return toString();
    }
  }
}

extension OptionalExtension<T> on T? {
  bool get isNull => this == null;

  bool get isNotNull => this != null;
}

extension BuildContextExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  Size get size => MediaQuery.sizeOf(this);
}

extension DateTimeExtension on DateTime {
  String toReadableString() {
    return DateFormat('yMMMd').format(this);
  }
}
