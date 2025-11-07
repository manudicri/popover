import 'package:flutter/material.dart';

class PopoverRoute<T> extends RawDialogRoute<T> {
  /// If true, widgets behind the barrier can receive pointer events.
  final bool allowClicksOnBackground;

  /// The duration for the reverse transition animation.
  final Duration? _reverseTransitionDuration;
  bool _workaroundComplete = false;

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
  }) : _reverseTransitionDuration = reverseTransitionDuration {
    // Schedule barrier rebuild after workaround period
    // workaround for https://github.com/flutter/flutter/issues/177992
    Future.delayed(const Duration(milliseconds: 500), () {
      _workaroundComplete = true;
      changedInternalState(); // This forces the barrier to rebuild
    });
  }

  @override
  Duration get reverseTransitionDuration => _reverseTransitionDuration ?? super.reverseTransitionDuration;

  @override
  Widget buildModalBarrier() {
    return IgnorePointer(
      ignoring: allowClicksOnBackground,
      child: super.buildModalBarrier(),
    );
  }

  @override
  bool get barrierDismissible {
    // workaround for https://github.com/flutter/flutter/issues/177992
    if (!_workaroundComplete) {
      return false;
    }
    return super.barrierDismissible;
  }
}
