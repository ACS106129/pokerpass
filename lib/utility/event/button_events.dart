import 'package:flame/game/game.dart';

mixin ButtonEvents on Game {
  void onButtonEvent(ButtonEvent e);
}

class ButtonEvent {
  final Object source;
  final String name;
  final ButtonState state;

  ButtonEvent(final this.source, final this.name, final this.state);

  @override
  String toString() {
    return '"$name"-$state of source: $source';
  }
}

enum ButtonState {
  Press,
  Hover,
  Release,
}
