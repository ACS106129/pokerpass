import 'package:flame/flame.dart';
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
  TextSpan upperCharTextSpan;
  TextSpan lowerCharTextSpan;
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
    upperSuitSprite = Sprite.fromImage(
        Flame.images.loadedFiles[toImagePath(upperSuit)].loadedImage);
    lowerSuitSprite = Sprite.fromImage(
        Flame.images.loadedFiles[toImagePath(lowerSuit)].loadedImage);
    upperCharTextSpan = TextSpan(
        text: upperChar,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ));
    lowerCharTextSpan = TextSpan(
        text: lowerChar,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ));
  }

  void render(final Canvas canvas) {
    final paint = Paint()..color = Colors.black;
    // card frame
    final cardRect =
        Rect.fromLTWH(position.x, position.y, size.width, size.height);
    canvas.drawRect(cardRect.inflate(1), paint);
    paint.color = Colors.white;
    canvas.drawRect(cardRect, paint);
    // two suits and two char
    upperSuitSprite.renderPosition(
        canvas, Position(size.width / 25, size.height / 25).add(position),
        size: Position(size.width / 2.5, size.height / 2.5));
    lowerSuitSprite.renderPosition(
        canvas, Position(size.width / 25, size.height * 0.56).add(position),
        size: Position(size.width / 2.5, size.height / 2.5));
    final textPainter = TextPainter(
        text: upperCharTextSpan,
        textAlign: TextAlign.justify,
        textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas,
        Position(size.width * 0.57, size.height / 27).add(position).toOffset());
    textPainter.text = lowerCharTextSpan;
    textPainter.layout();
    textPainter.paint(
        canvas,
        Position(size.width * 0.58, size.height * 0.5)
            .add(position)
            .toOffset());
  }
}
