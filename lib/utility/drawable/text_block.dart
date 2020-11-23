import 'package:flame/position.dart';
import 'package:flutter/cupertino.dart';

class TextBlock {
  final String text;
  final Position position;
  final TextStyle style;
  TextPainter _painter;

  TextBlock(final this.text, {final this.position, final this.style}) {
    _painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textAlign: TextAlign.justify,
        textDirection: TextDirection.ltr);
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
    _painter.paint(canvas, (position ?? this.position ?? Position.empty()).toOffset());
  }
}
