import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

/// View of the [Routes.style] page.
class AquariumView extends StatelessWidget {
  const AquariumView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AquariumController(),
      builder: (AquariumController c) {
        return MaterialApp(
          home: Scaffold(
            body: Obx(() {
              return Stack(
                key: c.aquariumKey,
                children: c.fishes
                    .map(
                      (e) => Positioned(
                        top: e.fish.top,
                        left: e.fish.left,
                        child: Container(
                          key: e.key,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          child: SizedBox(
                            width: e.width,
                            height: e.height,
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(
                                e.fish.direction.x < 0 ? pi : 0,
                              ),
                              child: Image.asset(
                                'assets/images/fish.png',
                                width: e.width,
                                height: e.height,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            }),
          ),
        );
      },
    );
  }
}
