import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:pokerpass/poker/component/suit.dart';

class SuitBlock {
  final Position position;
  final Size size;
  Suit _suit;
  Sprite _suitSprite;

  set suit(final Suit suit) {
    _suit = suit;
    _suitSprite = Sprite.fromImage(
        Flame.images.loadedFiles[toImagePath(_suit)].loadedImage);
  }

  Suit get suit => _suit;

  SuitBlock(final Suit suit, {final this.position, final this.size}) {
    this.suit = suit;
  }

  void render(final Canvas canvas, {final Position position, final Size size}) {
    _suitSprite.renderPosition(
        canvas, position ?? this.position ?? Position.empty(),
        size: Position.fromSize(size ?? this.size ?? Size.zero));
  }
}
