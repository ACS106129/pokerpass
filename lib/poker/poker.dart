import 'package:flame/game.dart';
import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerpass/poker/component/fly.dart';
import 'dart:math';

class PokerGame extends Game {
  final Random rnd = Random();
  final Size size;
  double tileSize;
  List<Fly> flies;

  PokerGame(this.size) {
    final Util flameUtil = Util();
    flameUtil.setOrientation(DeviceOrientation.portraitUp);
    flameUtil.fullScreen();
    initialize();
  }

  void initialize() {
    flies = [];
    tileSize = size.width / 9;
    spawnFly();
  }

  void spawnFly() {
    double x = rnd.nextDouble() * (size.width - tileSize);
    double y = rnd.nextDouble() * (size.height - tileSize);
    flies.add(Fly(this, x, y));
  }

  @override
  void render(Canvas canvas) {
    final Rect bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Paint bgPaint = Paint();
    bgPaint.color = Color(0xFFff0000);
    canvas.drawRect(bgRect, bgPaint);
    flies.forEach((fly) => fly.render(canvas));
  }

  @override
  void update(double t) {
    flies.forEach((fly) => fly.update(t));
  }
}
