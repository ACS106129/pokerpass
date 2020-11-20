import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerpass/poker/component/suit.dart';

class CharBlock {
  final String upperChar;
  final String lowerChar;
  final Suit upperSuit;
  final Suit lowerSuit;
  Sprite upperSuitSprite;
  Sprite lowerSuitSprite;
  Position position;
  Size size;

  CharBlock(
    final this.upperChar,
    final this.upperSuit,
    final this.lowerChar,
    final this.lowerSuit, {
    double x = 0.0,
    double y = 0.0,
    @required double width,
    @required double height,
  })  : position = Position(x, y),
        size = Size(width, height) {
    upperSuitSprite = Sprite(toFileString(upperSuit),
        x: x + width / 4,
        y: y - height / 4,
        width: width / 2.5,
        height: height / 2.5);
    lowerSuitSprite = Sprite(toFileString(lowerSuit),
        x: x + width / 4,
        y: y - height / 4,
        width: width / 2.5,
        height: height / 2.5);
  }

  void render(final Canvas canvas) {
    final paint = Paint();
    // card frame
    final Rect bgRect =
        Rect.fromLTWH(position.x, position.y, size.width, size.height);
    paint.color = Colors.black;
    canvas.drawRect(bgRect.inflate(1), paint);
    paint.color = Colors.white;
    canvas.drawRect(bgRect, paint);
    // two suits and two char
    if (upperSuitSprite?.loaded() ?? false) {
      upperSuitSprite.render(canvas);
    }
    if (lowerSuitSprite?.loaded() ?? false) lowerSuitSprite.render(canvas);
  }
}
