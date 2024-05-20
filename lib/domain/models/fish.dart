import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart';

class Fish {
  Fish({
    required this.size,
    required this.top,
    required this.left,
    required this.direction,
    int fishEaten = 0,
    Duration eatAgo = Duration.zero,
  })  : _fishEaten = fishEaten,
        _eatAgo = eatAgo;

  /// Constructs a [Fish] with a random fields.
  factory Fish.random({required double height, required double width}) {
    final Random random = Random();

    return Fish(
      size: random.nextInt(maxSize) + minSize,
      top: random.nextDouble() * height,
      left: random.nextDouble() * width,
      direction: Vector2RandomExtension.random(),
    );
  }

  /// Maximum size of a [Fish].
  static int maxSize = 5;

  /// Minimal size of a [Fish].
  static int minSize = 1;

  /// Size of this [Fish] form [minSize] to [maxSize].
  int size;

  /// Top position of this [Fish].
  double top;

  /// Lest position of this [Fish].
  double left;

  /// Move direction of this [Fish].
  Vector2 direction;

  /// [Duration] how long ago this [Fish] ate last time.
  Duration _eatAgo;

  /// Amount of fished this [Fish] has eaten.
  ///
  /// Drops to 0 when this [Fish] has eaten enough to increase its [size].
  int _fishEaten;

  set fishEaten(int count) {
    if (count == size && size < maxSize) {
      size += 1;
      _fishEaten = 0;
    } else if (count < 0) {
      if (size > minSize) {
        size -= 1;
        _fishEaten = 0;
      }
    } else {
      _fishEaten = count;
    }
  }

  set eatAgo(Duration duration) {
    if (duration >= const Duration(seconds: 5)) {
      fishEaten--;
      _eatAgo = Duration.zero;
    } else {
      _eatAgo = duration;
    }
  }

  int get fishEaten => _fishEaten;

  Duration get eatAgo => _eatAgo;
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
