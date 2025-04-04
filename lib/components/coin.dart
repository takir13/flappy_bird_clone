import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class Coin extends PositionComponent {
  Coin({required super.position}) : super(size: Vector2.all(24));

  @override
  void onLoad() {
    super.onLoad();
    add(CircleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final Paint goldPaint = Paint()..color = Color(0xFFFFD700);
    canvas.drawCircle(Offset.zero, size.x / 2, goldPaint);
  }
}
