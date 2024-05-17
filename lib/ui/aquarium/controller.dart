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

  /// [Timer] to move the [fishes].
  Timer? _fishesTimer;

  @override
  void onReady() {
    final BuildContext? context = aquariumKey.currentContext;

    if (context != null) {
      final box = context.findRenderObject() as RenderBox;

      List.generate(
        5,
        (_) => ViewFish(
          Fish.random(
            width: box.size.width - ViewFish.maxWidth,
            height: box.size.height - ViewFish.maxHeight,
          ),
        ),
      ).forEach(fishes.add);
    }

    _fishesTimer =
        Timer.periodic(const Duration(milliseconds: 17), (_) => moveFishes());

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

        final BuildContext? fishContext = e.key.currentContext;

        if (fishContext != null) {
          final fishBox = fishContext.findRenderObject() as RenderBox;

          Alignment? alignment;

          if (e.fish.left >= box.size.width - fishBox.size.width) {
            if (e.fish.top >= box.size.height - fishBox.size.height) {
              alignment = Alignment.bottomRight;
            } else {
              alignment = Alignment.centerRight;
            }
          } else if (e.fish.left <= 0) {
            if (e.fish.top <= 0) {
              alignment = Alignment.topLeft;
            } else {
              alignment = Alignment.centerLeft;
            }
          }

          if (e.fish.top >= box.size.height - fishBox.size.height) {
            alignment ??= Alignment.bottomCenter;
          } else if (e.fish.top <= 0) {
            alignment ??= Alignment.topCenter;
          }

          if (alignment != null) {
            e.fish.direction = Vector2RandomExtension.random(alignment);
          }
        }
      }
    }

    fishes.refresh();
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

  /// [GlobalKey] of this [ViewFish].
  GlobalKey key = GlobalKey();

  /// Width of this [ViewFish].
  double get width => (24 * fish.size).toDouble();

  /// Height of this [ViewFish].
  double get height => (12 * fish.size).toDouble();

  /// Speed of this [ViewFish].
  double get speed => (10 - fish.size) / 4;
}
