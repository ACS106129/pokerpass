import 'package:flame/position.dart';
import 'package:flutter/cupertino.dart';

class TextBlock {
  final Position position;
  final TextStyle style;
  String _text;
  TextPainter _painter;

  set text(String text) {
    _text = text;
    _painter = TextPainter(
        text: TextSpan(text: _text, style: style),
        textAlign: TextAlign.justify,
        textDirection: TextDirection.ltr);
  }

  String get text {
    return _text;
  }

  TextBlock(final String text, {final this.position, final this.style}) {
    this.text = text;
  }

  void render(final Canvas canvas,
      {final Position position, final TextStyle style}) {
    if (style != null) {
      _painter = TextPainter(
          text: TextSpan(text: text, style: style),
          textAlign: TextAlign.justify,
          textDirection: TextDirection.ltr);
    }
    _painter.layout();
    _painter.paint(
        canvas, (position ?? this.position ?? Position.empty()).toOffset());
  }
}
