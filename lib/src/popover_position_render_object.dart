import 'dart:math' as math;

import 'package:flutter/rendering.dart';

import 'popover_direction.dart';
import 'utils/popover_utils.dart';

final class PopoverPositionRenderObject extends RenderShiftedBox {
  late Rect _attachRect;
  double arrowHeight;
  BoxConstraints? _additionalConstraints;
  PopoverDirection? _direction;

  PopoverPositionRenderObject({
    required this.arrowHeight,
    required Rect attachRect,
    RenderBox? child,
    BoxConstraints? constraints,
    PopoverDirection? direction,
  }) : super(child) {
    _attachRect = attachRect;
    _additionalConstraints = constraints;
    _direction = direction;
  }

  BoxConstraints? get additionalConstraints => _additionalConstraints;
  set additionalConstraints(BoxConstraints? value) {
    if (_additionalConstraints == value) return;
    _additionalConstraints = value;
    markNeedsLayout();
  }

  Rect get attachRect => _attachRect;
  set attachRect(Rect value) {
    if (_attachRect == value) return;
    _attachRect = value;
    markNeedsLayout();
  }

  PopoverDirection? get direction => _direction;
  set direction(PopoverDirection? value) {
    if (_direction == value) return;
    _direction = value;
    markNeedsLayout();
  }

  Offset calculateOffset(Size size) {
    final _direction = PopoverUtils.popoverDirection(
      attachRect,
      size,
      arrowHeight,
      direction,
    );

    if (_direction == PopoverDirection.top || _direction == PopoverDirection.bottom) {
      return _dxOffset(_direction, _horizontalOffset(size), size);
    } else {
      return _dyOffset(_direction, _verticalOffset(size), size);
    }
  }
  /*
  @override
  void performLayout() {
    print('PopoverPositionRenderObject.performLayout() - child size before: ${child?.size}');
    // Prima faccio un layout per ottenere la dimensione preferita
    child!.layout(
      _additionalConstraints!.enforce(constraints),
      parentUsesSize: false,
    );

    // Calcolo la direzione finale
    final direction = PopoverUtils.popoverDirection(
      attachRect,
      child!.size,
      arrowHeight,
      _direction,
    );

    // Calcolo l'altezza disponibile per quella direzione
    final availableHeight = _calculateAvailableHeight(direction);

    // Se il child è troppo alto, rifaccio il layout con constraint limitato
    if (child!.size.height > availableHeight) {
      final adjustedConstraints = _additionalConstraints!.copyWith(
        maxHeight: availableHeight,
      );

      child!.layout(
        adjustedConstraints.enforce(constraints),
        parentUsesSize: true,
      );
    }

    size = Size(constraints.maxWidth, constraints.maxHeight);
    final childParentData = child!.parentData as BoxParentData;
    childParentData.offset = calculateOffset(child!.size);

    print('PopoverPositionRenderObject.performLayout() - child size after: ${child?.size}');
  }*/

  @override
  void performLayout() {
    // Calcola la direzione stimata senza fare layout
    final estimatedDirection = PopoverUtils.popoverDirection(
      attachRect,
      Size(constraints.maxWidth, constraints.maxHeight),
      arrowHeight,
      _direction,
    );

    // Calcola l'altezza disponibile subito
    final availableHeight = _calculateAvailableHeight(estimatedDirection);

    // UN SOLO LAYOUT con i constraints giusti
    final finalConstraints = _additionalConstraints!.copyWith(
      maxHeight: math.min(_additionalConstraints!.maxHeight, availableHeight),
    );

    child!.layout(
      finalConstraints.enforce(constraints),
      parentUsesSize: true,
    );

    size = Size(constraints.maxWidth, constraints.maxHeight);
    final childParentData = child!.parentData as BoxParentData;
    childParentData.offset = calculateOffset(child!.size);
  }

  Offset _dxOffset(
    PopoverDirection direction,
    double horizontalOffset,
    Size size,
  ) {
    if (direction == PopoverDirection.bottom) {
      return Offset(horizontalOffset, attachRect.bottom);
    } else {
      return Offset(horizontalOffset, attachRect.top - size.height);
    }
  }

  Offset _dyOffset(
    PopoverDirection _direction,
    double verticalOffset,
    Size size,
  ) {
    if (_direction == PopoverDirection.right) {
      return Offset(attachRect.right, verticalOffset);
    } else {
      return Offset(attachRect.left - size.width, verticalOffset);
    }
  }

  double _horizontalOffset(Size size) {
    var offset = 0.0;

    if (attachRect.left > size.width / 2 && PopoverUtils.physicalSize.width - attachRect.right > size.width / 2) {
      offset = attachRect.left + attachRect.width / 2 - size.width / 2;
    } else if (attachRect.left < size.width / 2) {
      offset = arrowHeight;
    } else {
      offset = PopoverUtils.physicalSize.width - arrowHeight - size.width;
    }
    return offset;
  }

  double _verticalOffset(Size size) {
    var offset = 0.0;

    if (attachRect.top > size.height / 2 && PopoverUtils.physicalSize.height - attachRect.bottom > size.height / 2) {
      offset = attachRect.top + attachRect.height / 2 - size.height / 2;
    } else if (attachRect.top < size.height / 2) {
      offset = arrowHeight;
    } else {
      offset = PopoverUtils.physicalSize.height - arrowHeight - size.height;
    }
    return offset;
  }

  double _calculateAvailableHeight(PopoverDirection direction) {
    final viewPadding = PopoverUtils.viewPadding;

    switch (direction) {
      case PopoverDirection.top:
        return attachRect.top - arrowHeight - viewPadding.top;
      case PopoverDirection.bottom:
        return PopoverUtils.physicalSize.height - attachRect.bottom - arrowHeight - viewPadding.bottom;
      case PopoverDirection.left:
      case PopoverDirection.right:
        return PopoverUtils.physicalSize.height - 2 * arrowHeight - viewPadding.top - viewPadding.bottom;
    }
  }
}
