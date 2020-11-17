import 'dart:ui';

import 'package:pokerpass/poker/poker.dart';

class Fly {
  final PokerGame game;
  Rect flyRect;
  Paint flyPaint;
  Fly(this.game, double x, double y) {
    flyRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
    flyPaint = Paint();
    flyPaint.color = Color(0xff6ab04c);
  }
  void render(Canvas c) {
    c.drawRect(flyRect, flyPaint);
  }

  void update(double t) {}
}
