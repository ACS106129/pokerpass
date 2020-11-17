import 'package:flame/game.dart';
import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/flame.dart';
import 'package:pokerpass/poker/component/fly.dart';
import 'dart:math';

class PokerGame extends Game {
  Size screenSize;
  double tileSize;
  List<Fly> flies;
  Random rnd;

  PokerGame(BuildContext context) {
    final Util flameUtil = Util();
    flameUtil.setOrientation(DeviceOrientation.portraitUp).then((_) => null);
    initialize();
  }

  void initialize() async {
    flies = List<Fly>();
    resize(await Flame.util.initialDimensions());

    rnd = Random();
    spawnFly();
  }

  void spawnFly() {
    double x = rnd.nextDouble() * (screenSize.width - tileSize);
    double y = rnd.nextDouble() * (screenSize.height - tileSize);
    flies.add(Fly(this, x, y));
  }

  void render(Canvas canvas) {
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, 510);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xFFff0000);
    canvas.drawRect(bgRect, bgPaint);
    flies.forEach((fly) => fly.render(canvas));
  }

  void update(double t) {
    flies.forEach((fly) => fly.update(t));
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }
}
