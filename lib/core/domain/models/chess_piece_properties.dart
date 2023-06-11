//

enum ChessPieceType {
  pawn,
  rock,
  knight,
  bishop,
  queen,
  king;
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
