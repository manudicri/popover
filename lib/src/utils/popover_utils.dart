import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../popover_direction.dart';

abstract class PopoverUtils {
  static PopoverDirection popoverDirection(
    Rect attachRect,
    Size size,
    double arrowHeight,
    PopoverDirection? direction,
  ) {
    // Calcola lo spazio disponibile in ogni direzione considerando viewPadding
    final padding = viewPadding;
    final spaceTop = attachRect.top - arrowHeight - padding.top;
    final spaceBottom = physicalSize.height - attachRect.bottom - arrowHeight - padding.bottom;
    final spaceLeft = attachRect.left - arrowHeight - padding.left;
    final spaceRight = physicalSize.width - attachRect.right - arrowHeight - padding.right;

    switch (direction) {
      case PopoverDirection.top:
      case PopoverDirection.bottom:
        // Per verticale: scegli la direzione con più spazio
        return spaceBottom >= spaceTop ? PopoverDirection.bottom : PopoverDirection.top;
      case PopoverDirection.left:
      case PopoverDirection.right:
        // Per orizzontale: scegli la direzione con più spazio
        return spaceRight >= spaceLeft ? PopoverDirection.right : PopoverDirection.left;
      default:
        // Default: scegli tra top e bottom basandoti sullo spazio
        return spaceBottom >= spaceTop ? PopoverDirection.bottom : PopoverDirection.top;
    }
  }

  static Size get physicalSize =>
      PlatformDispatcher.instance.views.first.physicalSize / PlatformDispatcher.instance.views.first.devicePixelRatio;

  static EdgeInsets get viewPadding {
    final view = PlatformDispatcher.instance.views.first;
    final dpr = view.devicePixelRatio;
    return EdgeInsets.fromLTRB(
      view.viewPadding.left / dpr,
      view.viewPadding.top / dpr,
      view.viewPadding.right / dpr,
      view.viewPadding.bottom / dpr,
    );
  }
}

typedef PopoverTransitionBuilder = Widget Function(
  Animation<double> animation,
  Widget child,
);
