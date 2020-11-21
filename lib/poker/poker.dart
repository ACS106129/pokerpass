import 'package:flame/game.dart';
import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerpass/poker/component/char_block.dart';
import 'package:pokerpass/poker/component/char_list.dart';
import 'package:pokerpass/poker/component/suit.dart';

class PokerGame extends Game {
  final Size screenSize;
  final Size pokerCardSize = Size(50, 50);

  PokerGame(final this.screenSize) {
    final Util flameUtil = Util();
    flameUtil.setOrientation(DeviceOrientation.portraitUp);
    flameUtil.fullScreen();
  }
  
  @override
  void render(final Canvas canvas) {
    final Rect bgRect =
        Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    final Paint paint = Paint();
    // background
    paint.color = Colors.white;
    canvas.drawRect(bgRect, paint);
    // target below
    for (int row = 0, index = 0; row < 4; row++) {
      for (int col = 0; col < 12; col++, index += 2) {
        final charBlock = CharBlock(
            charList[index], Suit.Spade, charList[index + 1], Suit.Club,
            x: screenSize.width / 13 * (col + 1) - pokerCardSize.width / 2,
            y: screenSize.height / 5 * (row + 1) - pokerCardSize.height / 2,
            width: pokerCardSize.width,
            height: pokerCardSize.height);
        charBlock.render(canvas);
      }
    }
  }

  @override
  void update(double t) {}
}
