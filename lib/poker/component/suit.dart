enum Suit {
  Spade,
  Heart,
  Diamond,
  Club,
}

String toImagePath(final Suit suit) {
  switch (suit) {
    case Suit.Spade:
      return 'spade.png';
    case Suit.Heart:
      return 'heart.png';
    case Suit.Diamond:
      return 'diamond.png';
    case Suit.Club:
      return 'club.png';
    default:
      throw new Exception('Suit $suit Error!');
  }
}
