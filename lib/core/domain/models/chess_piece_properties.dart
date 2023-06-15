//

enum ChessPieceType {
  pawn,
  rock,
  knight,
  bishop,
  queen,
  king;

  factory ChessPieceType.fromString(String text) {
    switch (text[0]) {
      case 'P':
      case 'p':
        return ChessPieceType.pawn;
      case 'r':
      case 'R':
        return ChessPieceType.rock;
      case 'b':
      case 'B':
        return ChessPieceType.bishop;
      case 'n':
      case 'N':
        return ChessPieceType.knight;
      case 'q':
      case 'Q':
        return ChessPieceType.queen;
      case 'k':
      case 'K':
        return ChessPieceType.king;

      default:
        return ChessPieceType.pawn;
    }
  }

  String get initial {
    return toString().split('.').last[0].toUpperCase();
  }

  static const List<String> potentialPieces = [
    'p',
    'P',
    'r',
    'R',
    'n',
    'N',
    'b',
    'B',
    'q',
    'Q',
    'k',
    'K'
  ];
}

enum ChessPieceColor {
  white,
  black;

  ChessPieceColor get opposite {
    switch (this) {
      case ChessPieceColor.white:
        return ChessPieceColor.black;
      case ChessPieceColor.black:
        return ChessPieceColor.white;
    }
  }
}
