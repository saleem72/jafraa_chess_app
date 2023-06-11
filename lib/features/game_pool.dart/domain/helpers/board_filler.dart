//

import '../../../../core/domain/models/chess_coordinate.dart';
import '../../../../core/domain/models/chess_notations.dart';
import '../../../../core/domain/models/chess_piece.dart';
import '../../../../core/domain/models/chess_piece_properties.dart';

class BoardFiller {
  List<ChessPiece> fill() {
    final white = coloredGroup(ChessPieceColor.white);
    final black = coloredGroup(ChessPieceColor.black);
    var newList = List<ChessPiece>.from(white)..addAll(black);
    return newList;
  }
}

List<ChessPiece> coloredGroup(ChessPieceColor color) {
  final mainRank = color == ChessPieceColor.black ? 8 : 1;
  final pawnsRank = color == ChessPieceColor.black ? 7 : 2;
  final List<ChessPiece> result = [];
  result.add(
    ChessPiece.rock(
      color: color,
      coordinate: ChessCoordinate(file: FileNotation.a, rank: mainRank),
    ),
  );
  result.add(
    ChessPiece.knight(
      color: color,
      coordinate: ChessCoordinate(file: FileNotation.b, rank: mainRank),
    ),
  );
  result.add(
    ChessPiece.bishop(
      color: color,
      coordinate: ChessCoordinate(file: FileNotation.c, rank: mainRank),
    ),
  );
  result.add(
    ChessPiece.queen(
      color: color,
      coordinate: ChessCoordinate(file: FileNotation.d, rank: mainRank),
    ),
  );
  result.add(
    ChessPiece.king(
      color: color,
      coordinate: ChessCoordinate(file: FileNotation.e, rank: mainRank),
    ),
  );
  result.add(
    ChessPiece.bishop(
      color: color,
      coordinate: ChessCoordinate(file: FileNotation.f, rank: mainRank),
    ),
  );
  result.add(
    ChessPiece.knight(
      color: color,
      coordinate: ChessCoordinate(file: FileNotation.g, rank: mainRank),
    ),
  );
  result.add(
    ChessPiece.rock(
      color: color,
      coordinate: ChessCoordinate(file: FileNotation.h, rank: mainRank),
    ),
  );

  final pawns = FileNotation.values.map(
    (e) => ChessPiece.pawn(
      color: color,
      coordinate: ChessCoordinate(file: e, rank: pawnsRank),
    ),
  );
  result.addAll(pawns);
  return result;
}
