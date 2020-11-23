import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:pokerpass/poker/component/suit.dart';

class SuitBlock {
  final Suit suit;
  final Position position;
  final Size size;
  Sprite _suitSprite;

  SuitBlock(final this.suit, {final this.position, final this.size})
      : _suitSprite = Sprite.fromImage(
            Flame.images.loadedFiles[toImagePath(suit)].loadedImage);

  void render(final Canvas canvas, {final Position position, final Size size}) {
    _suitSprite.renderPosition(canvas, position ?? this.position ?? Position.empty(),
        size: Position.fromSize(size ?? this.size ?? Size.zero));
  }
}
