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
import 'package:pokerpass/utility/event/button_events.dart';

class PokerGame extends Game with KeyboardEvents, ButtonEvents {
  final pokerCardSize = Size(50, 50);
  final Size screenSize;
  final responseBlocks = <ResponseBlock>[];
  final charBlocks = <TextBlock>[];
  final suitBlocks = <SuitBlock>[];
  final Random random;
  int firstchallenge, secondchallenge;
  TextBlock textBlock;
  bool suitcheck = false;
  bool firstphase = false;
  bool secondphase = false;
  bool checkpass = true;
  bool challengecheck1 = false;
  bool challengecheck2 = false;
  List shuffledsuit = [];
  String security = "security";
  int count = 4;
  int phase = 1;
  List<String> challengestring = [
    'A',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    'J',
    'Q',
    'K'
  ];
  PokerGame(final this.screenSize, final int seedValue, final String password)
      : random = Random(seedValue) {
    if (password == security.substring(0, 4)) firstphase = true;
    final Util flameUtil = Util();
    flameUtil.setOrientation(DeviceOrientation.portraitUp);
    flameUtil.fullScreen();
    firstchallenge = random.nextInt(13);
    secondchallenge = random.nextInt(13);
    textBlock = TextBlock(
        '一階段挑戰碼' +
            challengestring[firstchallenge - 1] +
            '\n二階段挑戰碼' +
            challengestring[secondchallenge - 1],
        style: TextStyle(
          color: Colors.blue,
          fontSize: 20,
        ));
    List a = List.filled(24, Suit.values); //a is a variable before shuffle
    List number = new List();
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
      shuffledsuit.addAll(item);
    });
    shuffledsuit.shuffle();
    for (int row = 0, index = 0; row < 4; row++) {
      for (int col = 0; col < 12; col++, index += 2) {
        final resBlockPos = Position(
            screenSize.width / 13 * (col + 1) - pokerCardSize.width / 2,
            screenSize.height / 5 * (row + 1) - pokerCardSize.height / 2);
        responseBlocks.add(ResponseBlock(charList[index], shuffledsuit[index],
            charList[index + 1], shuffledsuit[index + 1],
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
    suitBlocks.forEach((suitBlock) => suitBlock.render(canvas));
    if (phase == 2) {
      charBlocks.forEach((charBlock) => charBlock.render(canvas));
      textBlock.render(canvas);
    }
  }

  @override
  void update(double t) {
    if (phase == 2 && checkpass == true)
      secondphase = true;
    else
      secondphase = false;
    // textfield password 4 chars
    // phase 1 remain chars if success >> secondphase=true
    // phase 2 challenge codes
  }

  @override
  void onButtonEvent(ButtonEvent e) {
    if (e.state == ButtonState.Press && e.name == "輸入" && phase == 1) {
      if (shuffledsuit[charList.indexOf(security[count])] !=
          suitBlocks[(charList.indexOf(security[count]) / 24).floor()].suit)
        checkpass = false;
      count++;
    } else if (e.state == ButtonState.Press && e.name == "清除" && phase == 1) {
      checkpass = true;
      count = 4;
    } else if (e.state == ButtonState.Press && e.name == "輸入" && phase == 2) {
      checkChallengeCode(security, 1);
    }
  }

  void checkChallengeCode(final String password, final int checkOrder) {
    var res = responseBlocks[(charList.indexOf(password[4]) / 2).floor()];
    int targetSuitIndex;
    if (charList.indexOf(password[4]) % 2 == 0)
      targetSuitIndex = suitBlocks
          .indexWhere((element) => element.suit == res.lowerSuitBlock.suit);
    else
      targetSuitIndex = suitBlocks
          .indexWhere((element) => element.suit == res.upperSuitBlock.suit);
    var passwordPosition =
        (charList.indexOf(password[password.length - checkOrder]) / 2).floor();
    var targetChar =
        charBlocks[passwordPosition % 12 + 12 * targetSuitIndex].text.trim();
    var challenge = checkOrder == 1 ? firstchallenge : secondchallenge;
    if (targetChar == challengestring[challenge - 1] ||
        targetChar == challengestring[challenge % 13])
      checkOrder == 1 ? challengecheck1 = true : challengecheck2 = true;
  }

  @override
  void onKeyEvent(RawKeyEvent e) {
    //final bool isKeyDown = e is RawKeyDownEvent;
    //print(" Key: ${e.data.keyLabel} - isKeyDown: $isKeyDown");
    if (e.isKeyPressed(LogicalKeyboardKey.arrowUp) && firstphase == true) {
      var texts = charBlocks.map((e) => e.text).toList();
      var index = (texts.length / 4).floor();
      var suits = suitBlocks.map((e) => e.suit).toList();
      var index2 = 1;
      charBlocks.forEach((e) => e.text = texts[index++ % texts.length]);
      suitBlocks.forEach((e) => e.suit = suits[index2++ % suits.length]);
    } else if (e.isKeyPressed(LogicalKeyboardKey.arrowDown) &&
        firstphase == true) {
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
