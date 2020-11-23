import 'package:flame/position.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerpass/poker/component/suit.dart';
import 'package:pokerpass/utility/drawable/suit_block.dart';
import 'package:pokerpass/utility/drawable/text_block.dart';

class ResponseBlock {
  SuitBlock upperSuitBlock;
  SuitBlock lowerSuitBlock;
  TextBlock upperCharBlock;
  TextBlock lowerCharBlock;
  Position position;
  Size size;

  ResponseBlock(
    final String upperChar,
    final Suit upperSuit,
    final String lowerChar,
    final Suit lowerSuit, {
    double x = 0.0,
    double y = 0.0,
    @required double width,
    @required double height,
  })  : position = Position(x, y),
        size = Size(width, height) {
    final suitSize = Size(size.width * 0.32, size.height * 0.32);
    upperSuitBlock = SuitBlock(upperSuit,
        position: Position(size.width / 10, size.height / 10).add(position),
        size: suitSize);
    lowerSuitBlock = SuitBlock(lowerSuit,
        position: Position(size.width / 10, size.height * 0.58).add(position),
        size: suitSize);
    upperCharBlock = TextBlock(upperChar,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        position: Position(size.width * 0.57, size.height / 27).add(position));
    lowerCharBlock = TextBlock(lowerChar,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        position: Position(size.width * 0.58, size.height * 0.5).add(position));
  }

  void render(final Canvas canvas) {
    final paint = Paint()..color = Colors.black;
    // card frame
    final cardRect =
        Rect.fromLTWH(position.x, position.y, size.width, size.height);
    canvas.drawRect(cardRect.inflate(1), paint);
    paint.color = Colors.white;
    canvas.drawRect(cardRect, paint);
    // two suits
    upperSuitBlock.render(canvas);
    lowerSuitBlock.render(canvas);
    // two char
    upperCharBlock.render(canvas);
    lowerCharBlock.render(canvas);
  }
}
