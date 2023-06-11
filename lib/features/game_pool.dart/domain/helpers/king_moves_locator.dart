//

import 'package:jafraa_chess_app/features/game_pool.dart/domain/extensions/chess_piece_list_extension.dart';

import '../../../../core/domain/models/chess_coordinate.dart';
import '../../../../core/domain/models/chess_notations.dart';
import '../../../../core/domain/models/chess_piece.dart';

class KingMovesLocator {
  // TODO: castling long & short
  List<ChessCoordinate> locate(List<ChessPiece> board, ChessPiece piece,
      {bool includeSameColorPieces = false}) {
    final List<ChessCoordinate> rawRessult = [];
    final file = piece.coordinate.file.value;
    final rank = piece.coordinate.rank;
    int newFile = -1;
    int newRank = -1;

    // [-1, -1]
    newFile = file - 1;
    newRank = rank - 1;
    if (board.isOnBoard(file: newFile, rank: newRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(newFile),
        rank: newRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);
      if (crossedPiece != null) {
        if (crossedPiece.color != piece.color) {
          rawRessult.add(coordinate);
        } else {
          if (includeSameColorPieces) {
            rawRessult.add(coordinate);
          }
        }
      } else {
        rawRessult.add(coordinate);
      }
    }

    // [+1, +1]
    newFile = file + 1;
    newRank = rank + 1;
    if (board.isOnBoard(file: newFile, rank: newRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(newFile),
        rank: newRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);
      if (crossedPiece != null) {
        if (crossedPiece.color != piece.color) {
          rawRessult.add(coordinate);
        } else {
          if (includeSameColorPieces) {
            rawRessult.add(coordinate);
          }
        }
      } else {
        rawRessult.add(coordinate);
      }
    }

    // [-1, +1]
    newFile = file - 1;
    newRank = rank + 1;
    if (board.isOnBoard(file: newFile, rank: newRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(newFile),
        rank: newRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);
      if (crossedPiece != null) {
        if (crossedPiece.color != piece.color) {
          rawRessult.add(coordinate);
        } else {
          if (includeSameColorPieces) {
            rawRessult.add(coordinate);
          }
        }
      } else {
        rawRessult.add(coordinate);
      }
    }
    // [+1, -1]
    newFile = file + 1;
    newRank = rank - 1;
    if (board.isOnBoard(file: newFile, rank: newRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(newFile),
        rank: newRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);
      if (crossedPiece != null) {
        if (crossedPiece.color != piece.color) {
          rawRessult.add(coordinate);
        } else {
          if (includeSameColorPieces) {
            rawRessult.add(coordinate);
          }
        }
      } else {
        rawRessult.add(coordinate);
      }
    }

    newFile = file;
    newRank = rank - 1;
    if (board.isOnBoard(file: newFile, rank: newRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(newFile),
        rank: newRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);
      if (crossedPiece != null) {
        if (crossedPiece.color != piece.color) {
          rawRessult.add(coordinate);
        } else {
          if (includeSameColorPieces) {
            rawRessult.add(coordinate);
          }
        }
      } else {
        rawRessult.add(coordinate);
      }
    }

    newFile = file;
    newRank = rank + 1;
    if (board.isOnBoard(file: newFile, rank: newRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(newFile),
        rank: newRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);
      if (crossedPiece != null) {
        if (crossedPiece.color != piece.color) {
          rawRessult.add(coordinate);
        } else {
          if (includeSameColorPieces) {
            rawRessult.add(coordinate);
          }
        }
      } else {
        rawRessult.add(coordinate);
      }
    }

    newFile = file - 1;
    newRank = rank;
    if (board.isOnBoard(file: newFile, rank: newRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(newFile),
        rank: newRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);
      if (crossedPiece != null) {
        if (crossedPiece.color != piece.color) {
          rawRessult.add(coordinate);
        } else {
          if (includeSameColorPieces) {
            rawRessult.add(coordinate);
          }
        }
      } else {
        rawRessult.add(coordinate);
      }
    }

    newFile = file + 1;
    newRank = rank;
    if (board.isOnBoard(file: newFile, rank: newRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(newFile),
        rank: newRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);
      if (crossedPiece != null) {
        if (crossedPiece.color != piece.color) {
          rawRessult.add(coordinate);
        } else {
          if (includeSameColorPieces) {
            rawRessult.add(coordinate);
          }
        }
      } else {
        rawRessult.add(coordinate);
      }
    }

    if (includeSameColorPieces) {
      return rawRessult;
    }

    final List<ChessCoordinate> result = [];

    for (final coordinate in rawRessult) {
      final newBoard =
          board.map((e) => e == piece ? piece.moveTo(coordinate) : e).toList();
      if (!newBoard.touchedByAnotherPiece(coordinate, piece.color.opposite)) {
        result.add(coordinate);
      }
    }
    return result;
  }
}
