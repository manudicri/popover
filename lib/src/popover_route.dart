import 'package:flutter/material.dart';

class PopoverRoute<T> extends RawDialogRoute<T> {
  /// If true, widgets behind the barrier can receive pointer events.
  final bool allowClicksOnBackground;

  /// The duration for the reverse transition animation.
  final Duration? _reverseTransitionDuration;

  PopoverRoute({
    required super.pageBuilder,
    super.anchorPoint,
    super.barrierColor,
    super.barrierDismissible,
    super.barrierLabel,
    super.settings,
    super.transitionBuilder,
    super.transitionDuration,
    super.traversalEdgeBehavior,
    Duration? reverseTransitionDuration,
    this.allowClicksOnBackground = false,
  }) : _reverseTransitionDuration = reverseTransitionDuration;

  @override
  Duration get reverseTransitionDuration => _reverseTransitionDuration ?? super.reverseTransitionDuration;

  @override
  Widget buildModalBarrier() {
    return IgnorePointer(
      ignoring: allowClicksOnBackground,
      child: super.buildModalBarrier(),
    );
  }
}
