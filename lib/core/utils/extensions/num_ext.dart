import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────
/// Number extensions — sizing helpers.
/// ─────────────────────────────────────────────────────────────
extension NumExt on num {
  /// Vertical spacing box.
  SizedBox get h => SizedBox(height: toDouble());

  /// Horizontal spacing box.
  SizedBox get w => SizedBox(width: toDouble());

  /// Symmetric padding.
  EdgeInsets get all => EdgeInsets.all(toDouble());

  /// Horizontal padding.
  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: toDouble());

  /// Vertical padding.
  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: toDouble());

  /// Border radius.
  BorderRadius get radius => BorderRadius.circular(toDouble());

  /// Clamp to 0‑1 (useful for opacity / progress).
  double get clamped01 => toDouble().clamp(0.0, 1.0);

  /// Duration helpers.
  Duration get ms => Duration(milliseconds: toInt());
  Duration get sec => Duration(seconds: toInt());
  Duration get min => Duration(minutes: toInt());
}

/// Spacing shorthand — `Spacing.sm.gap` returns SizedBox.
extension SpacingGap on double {
  /// Returns a [SizedBox] with this height (vertical gap).
  SizedBox get gap => SizedBox(height: this);

  /// Returns a [SizedBox] with this width (horizontal gap).
  SizedBox get hGap => SizedBox(width: this);
}
