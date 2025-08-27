import 'package:flutter/material.dart';

import 'popover_direction.dart';
import 'popover_render_shifted_box.dart';
import 'popover_transition.dart';

final class PopoverContext extends SingleChildRenderObjectWidget {
  final PopoverTransition transition;
  final Animation<double> animation;
  final Rect attachRect;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final double? radius;
  final PopoverDirection? direction;
  final double? arrowWidth;
  final double arrowHeight;
  final Curve curve;
  final Curve? reverseCurve;

  const PopoverContext({
    required this.transition,
    required this.animation,
    required this.attachRect,
    required this.arrowHeight,
    super.child,
    this.backgroundColor,
    this.boxShadow,
    this.radius,
    this.direction,
    this.arrowWidth,
    this.curve = Curves.easeOut,
    this.reverseCurve,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return PopoverRenderShiftedBox(
      attachRect: attachRect,
      color: backgroundColor,
      boxShadow: boxShadow,
      scale: animation.value,
      direction: direction,
      radius: radius,
      arrowWidth: arrowWidth,
      arrowHeight: arrowHeight,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    PopoverRenderShiftedBox renderObject,
  ) {
    if (transition == PopoverTransition.scale) {
      if (animation.status == AnimationStatus.reverse && reverseCurve != null) {
        renderObject.scale = reverseCurve!.transform(animation.value);
      } else {
        renderObject.scale = curve.transform(animation.value);
      }
    } else {
      renderObject.scale = 1.0;
    }

    renderObject
      ..attachRect = attachRect
      ..color = backgroundColor
      ..boxShadow = boxShadow
      ..direction = direction
      ..radius = radius
      ..arrowWidth = arrowWidth
      ..arrowHeight = arrowHeight;
  }
}
