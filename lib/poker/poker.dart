import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/keyboard.dart';
import 'package:flame/position.dart';
import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerpass/poker/component/char_list.dart';
import 'package:pokerpass/poker/component/number_list.dart';
import 'package:pokerpass/poker/component/response_block.dart';
import 'package:pokerpass/poker/component/suit.dart';
import 'package:pokerpass/utility/drawable/suit_block.dart';
import 'package:pokerpass/utility/drawable/text_block.dart';

class PokerGame extends Game with KeyboardEvents {
  final pokerCardSize = Size(50, 50);
  final Size screenSize;
  final responseBlocks = <ResponseBlock>[];
  final charBlocks = <TextBlock>[];
  final suitBlocks = <SuitBlock>[];
  final Random random;
  int firstchallenge,secondchallenge;
  TextBlock textBlock;
  bool suitcheck = false;
  bool secondphase = false;
  PokerGame(final this.screenSize, final int seedValue)
      : random = Random(seedValue) {
    final Util flameUtil = Util();
    flameUtil.setOrientation(DeviceOrientation.portraitUp);
    flameUtil.fullScreen();
    firstchallenge=random.nextInt(13);
    secondchallenge=random.nextInt(13);
    textBlock = TextBlock('一階段挑戰碼' + firstchallenge.toString() +',二階段挑戰碼'+secondchallenge.toString(),
        style: TextStyle(
          color: Colors.blue,
          fontSize: 20,
        ));
    List a = List.filled(24, Suit.values);
    List number = new List();
    List c = new List();
    for (int i = 0; i < 4; i++) {
      List origin = List.filled(1, numberList); // A ~ K
      List sforigin = new List();
      origin.forEach((item) {
        sforigin.addAll(item);
      });
      sforigin.shuffle();
      for (int j = 0; j < 12; j++) number.add(sforigin[j]);
    }
    a.forEach((item) {
      c.addAll(item);
    });
    c.shuffle();
    for (int row = 0, index = 0; row < 4; row++) {
      for (int col = 0; col < 12; col++, index += 2) {
        final resBlockPos = Position(
            screenSize.width / 13 * (col + 1) - pokerCardSize.width / 2,
            screenSize.height / 5 * (row + 1) - pokerCardSize.height / 2);
        responseBlocks.add(ResponseBlock(
            charList[index], c[index], charList[index + 1], c[index + 1],
            x: resBlockPos.x,
            y: resBlockPos.y,
            width: pokerCardSize.width,
            height: pokerCardSize.height));
        // initial char blocks with response block positions
        charBlocks.add(TextBlock(number[(index / 2).floor()],
            position: Position(resBlockPos.x + pokerCardSize.width / 2 - 12,
                resBlockPos.y + pokerCardSize.height),
            style: TextStyle(color: Colors.black, fontSize: 25)));
        if (suitcheck == false) {
          suitBlocks.add(SuitBlock(Suit.values[row],
              position: Position(
                  resBlockPos.x -
                      pokerCardSize.width / 5 -
                      pokerCardSize.width / 2,
                  resBlockPos.y + pokerCardSize.height / 4),
              size: Size(25, 25)));
          suitcheck = true;
        }
      }
      suitcheck = false;
    }
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
    responseBlocks.forEach((charBlock) => charBlock.render(canvas));
    charBlocks.forEach((charBlock) => charBlock.render(canvas));
    suitBlocks.forEach((suitBlock) => suitBlock.render(canvas));
    textBlock.render(canvas);
  }

  @override
  void update(double t) {
    // textfield password 4 chars
    // phase 1 remain chars  if success >> secondphase=true
    // phase 2 challenge codes
  }

  @override
  void onKeyEvent(e) {
    final bool isKeyDown = e is RawKeyDownEvent;
    print(" Key: ${e.data.keyLabel} - isKeyDown: $isKeyDown");
    if (e.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      var texts = charBlocks.map((e) => e.text).toList();
      var index = (texts.length / 4).floor();
      var suits = suitBlocks.map((e) => e.suit).toList();
      var index2 = 1;
      charBlocks.forEach((e) => e.text = texts[index++ % texts.length]);
      suitBlocks.forEach((e) => e.suit = suits[index2++ % suits.length]);
    } else if (e.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      var texts = charBlocks.map((e) => e.text).toList();
      var index = (texts.length * 3 / 4).floor();
      var suits = suitBlocks.map((e) => e.suit).toList();
      var index2 = 3;
      charBlocks.forEach((e) => e.text = texts[index++ % texts.length]);
      suitBlocks.forEach((e) => e.suit = suits[index2++ % suits.length]);
    } else if (e.isKeyPressed(LogicalKeyboardKey.arrowRight) &&
        secondphase == true) {
      var texts = charBlocks.map((e) => e.text).toList();
      var index = 0;
      charBlocks.forEach((e) {
        e.text = texts[index % 12 != 0 ? index - 1 : index + 11];
        index += 1;
      });
    } else if (e.isKeyPressed(LogicalKeyboardKey.arrowLeft) &&
        secondphase == true) {
      var texts = charBlocks.map((e) => e.text).toList();
      var index = 0;
      charBlocks.forEach((e) {
        e.text = texts[(index + 1) % 12 != 0 ? index + 1 : index - 11];
        index += 1;
      });
    }
  }
}
