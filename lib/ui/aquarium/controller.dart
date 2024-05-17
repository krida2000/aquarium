import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '/domain/models/fish.dart';

/// Controller of an [AquariumView].
class AquariumController extends GetxController {
  /// List of [ViewFish]es to display.
  final RxList<ViewFish> fishes = RxList<ViewFish>();

  /// [GlobalKey] of the aquarium box.
  final GlobalKey aquariumKey = GlobalKey();

  /// [Timer] to move and eat the [fishes].
  Timer? _fishesTimer;

  /// Period of the [_fishesTimer].
  final Duration _period = const Duration(milliseconds: 17);

  @override
  void onReady() {
    for (int i = 0; i < 5; i++) {
      addFish();
    }

    _fishesTimer = Timer.periodic(
      _period,
      (_) {
        moveFishes();
        eatFishes();
      },
    );

    super.onReady();
  }

  @override
  void dispose() {
    _fishesTimer?.cancel();
    super.dispose();
  }

  /// Move the [fishes] according to their [Fish.direction].
  void moveFishes() {
    for (var e in fishes) {
      e.fish.top += e.fish.direction.y * e.speed;
      e.fish.left += e.fish.direction.x * e.speed;

      final BuildContext? context = aquariumKey.currentContext;

      if (context != null) {
        final box = context.findRenderObject() as RenderBox;

        Alignment? alignment;

        if (e.fish.left >= box.size.width - e.width) {
          e.fish.left = box.size.width - e.width;
          if (e.fish.top >= box.size.height - e.height) {
            alignment = Alignment.bottomRight;
          } else {
            alignment = Alignment.centerRight;
          }
        } else if (e.fish.left <= 0) {
          e.fish.left = 0;
          if (e.fish.top <= 0) {
            alignment = Alignment.topLeft;
          } else {
            alignment = Alignment.centerLeft;
          }
        }

        if (e.fish.top >= box.size.height - e.height) {
          e.fish.top = box.size.height - e.height;
          alignment ??= Alignment.bottomCenter;
        } else if (e.fish.top <= 0) {
          e.fish.top = 0;
          alignment ??= Alignment.topCenter;
        }

        if (alignment != null) {
          e.fish.direction = Vector2RandomExtension.random(alignment);
        }
      }
    }

    fishes.refresh();
  }

  /// Make the [fishes] eat each other according to their size and position.
  void eatFishes() {
    for (var i = 0; i < fishes.length; i++) {
      final fish = fishes[i];
      final fishRect =
          Rect.fromLTWH(fish.fish.left, fish.fish.top, fish.width, fish.height);

      for (var j = i + 1; j < fishes.length; j++) {
        final other = fishes[j];
        final otherFishRect = Rect.fromLTWH(
          other.fish.left,
          other.fish.top,
          other.width,
          other.height,
        );

        final Rect intersection = fishRect.intersect(otherFishRect);

        if (intersection.width > 0 && intersection.height > 0) {
          if (fish.fish.size > other.fish.size) {
            fish.fish.fishEaten++;
            fish.fish.eatAgo = Duration.zero;
            fishes.remove(other);
            addFish();
          } else if (fish.fish.size < other.fish.size) {
            other.fish.fishEaten++;
            other.fish.eatAgo = Duration.zero;
            fishes.remove(fish);
            addFish();
          }
        }
      }

      fish.fish.eatAgo += _period;
    }
  }

  /// Add a new [Fish] to the [fishes].
  void addFish() {
    final BuildContext? context = aquariumKey.currentContext;

    if (context != null) {
      final box = context.findRenderObject() as RenderBox;

      fishes.add(
        ViewFish(
          Fish.random(
            width: box.size.width - ViewFish.maxWidth,
            height: box.size.height - ViewFish.maxHeight,
          ),
        ),
      );
    }
  }
}

/// Wrapper around a [Fish] to display in an [AquariumView].
class ViewFish {
  ViewFish(this.fish);

  /// Maximum width of a [ViewFish].
  static double maxWidth = 24 * 5;

  /// Maximum height of a [ViewFish].
  static double maxHeight = 12 * 5;

  /// [Fish] of this [ViewFish].
  Fish fish;

  /// Width of this [ViewFish].
  double get width => (24 * fish.size).toDouble();

  /// Height of this [ViewFish].
  double get height => (12 * fish.size).toDouble();

  /// Speed of this [ViewFish].
  double get speed => (10 - fish.size) / 4;
}
