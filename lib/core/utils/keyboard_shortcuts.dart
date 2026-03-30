import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Extension to make keyboard shortcut registration cleaner.
class KeyboardShortcuts {
  static const cmdK = SingleActivator(LogicalKeyboardKey.keyK, meta: true);
  static const cmdShiftN =
      SingleActivator(LogicalKeyboardKey.keyN, meta: true, shift: true);
  static const cmdShiftP =
      SingleActivator(LogicalKeyboardKey.keyP, meta: true, shift: true);
  static const cmdE =
      SingleActivator(LogicalKeyboardKey.keyE, meta: true);
  static const cmdSlash =
      SingleActivator(LogicalKeyboardKey.slash, meta: true);
  static const cmdF =
      SingleActivator(LogicalKeyboardKey.keyF, meta: true);
  static const cmdS =
      SingleActivator(LogicalKeyboardKey.keyS, meta: true);
  static const cmdW =
      SingleActivator(LogicalKeyboardKey.keyW, meta: true);
  static const cmdN =
      SingleActivator(LogicalKeyboardKey.keyN, meta: true);
  static const cmdZ =
      SingleActivator(LogicalKeyboardKey.keyZ, meta: true);
  static const cmdShiftZ =
      SingleActivator(LogicalKeyboardKey.keyZ, meta: true, shift: true);
}
