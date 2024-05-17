import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart';

class Fish {
  Fish({
    required this.size,
    required this.top,
    required this.left,
    required this.direction,
  });

  /// Constructs a [Fish] with a random fields.
  factory Fish.random({required double height, required double width}) {
    final Random random = Random();

    return Fish(
      size: random.nextInt(5) + 1,
      top: random.nextDouble() * height,
      left: random.nextDouble() * width,
      direction: Vector2RandomExtension.random(),
    );
  }

  /// Size of this [Fish] form 1 to 5.
  int size;

  /// Top position of this [Fish].
  double top;

  /// Lest position of this [Fish].
  double left;

  /// Move direction of this [Fish].
  Vector2 direction;
}

extension Vector2RandomExtension on Vector2 {
  /// Returns a random [Vector2] with length = 1 (`x² + y² = 1`).
  static Vector2 random([Alignment? alignment]) {
    final Random random = Random();

    double x = random.nextDouble();
    double y = sqrt(1 - x * x);

    switch (alignment) {
      case Alignment.topLeft:
        // [x] and [y] are already positive.
        break;

      case Alignment.centerLeft:
        // [x] is already positive.
        y = y * (random.nextBool() ? 1 : -1);
        break;

      case Alignment.topCenter:
        // [y] is already positive.
        x = x * (random.nextBool() ? 1 : -1);
        break;

      case Alignment.topRight:
      case Alignment.centerRight:
        x = -x;
        y = y * (random.nextBool() ? 1 : -1);
        break;

      case Alignment.bottomLeft:
      case Alignment.bottomCenter:
        x = x * (random.nextBool() ? 1 : -1);
        y = -y;
        break;

      case Alignment.bottomRight:
        x = -x;
        y = -y;
        break;

      default:
        x = x * (random.nextBool() ? 1 : -1);
        y = y * (random.nextBool() ? 1 : -1);
        break;
    }

    return Vector2(x, y);
  }
}
