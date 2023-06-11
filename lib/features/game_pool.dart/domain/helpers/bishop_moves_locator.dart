//

import 'package:jafraa_chess_app/features/game_pool.dart/domain/extensions/chess_piece_list_extension.dart';

import '../../../../core/domain/models/chess_coordinate.dart';
import '../../../../core/domain/models/chess_notations.dart';
import '../../../../core/domain/models/chess_piece.dart';

class BishopMovesLocator {
  List<ChessCoordinate> locate(List<ChessPiece> board, ChessPiece piece,
      {bool includeSameColorPieces = false}) {
    final List<ChessCoordinate> result = [];
    final file = piece.coordinate.file.value;
    final rank = piece.coordinate.rank;
    int newFile = -1;
    int newRank = -1;

    // [-1, -1]
    newFile = file - 1;
    newRank = rank - 1;
    while (true) {
      if (board.isOnBoard(file: newFile, rank: newRank)) {
        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );
        final crossedPiece = board.atCoordinates(coordinate);
        if (crossedPiece != null) {
          if (crossedPiece.color == piece.color) {
            if (includeSameColorPieces) {
              result.add(coordinate);
            }
            break;
          } else {
            result.add(coordinate);
            break;
          }
        }
        result.add(coordinate);
        newFile--;
        newRank--;
      } else {
        break;
      }
    }

    // [+1, +1]
    newFile = file + 1;
    newRank = rank + 1;
    while (true) {
      if (board.isOnBoard(file: newFile, rank: newRank)) {
        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );
        final crossedPiece = board.atCoordinates(coordinate);
        if (crossedPiece != null) {
          if (crossedPiece.color == piece.color) {
            if (includeSameColorPieces) {
              result.add(coordinate);
            }
            break;
          } else {
            result.add(coordinate);
            break;
          }
        }
        result.add(coordinate);
        newFile++;
        newRank++;
      } else {
        break;
      }
    }

    // [-1, +1]
    newFile = file - 1;
    newRank = rank + 1;
    while (true) {
      if (board.isOnBoard(file: newFile, rank: newRank)) {
        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );

        final crossedPiece = board.atCoordinates(coordinate);
        if (crossedPiece != null) {
          if (crossedPiece.color == piece.color) {
            if (includeSameColorPieces) {
              result.add(coordinate);
            }
            break;
          } else {
            result.add(coordinate);
            break;
          }
        }
        result.add(coordinate);
        newFile--;
        newRank++;
      } else {
        break;
      }
    }

    // [+1, -1]
    newFile = file + 1;
    newRank = rank - 1;
    while (true) {
      if (board.isOnBoard(file: newFile, rank: newRank)) {
        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );
        final crossedPiece = board.atCoordinates(coordinate);
        if (crossedPiece != null) {
          if (crossedPiece.color == piece.color) {
            if (includeSameColorPieces) {
              result.add(coordinate);
            }
            break;
          } else {
            result.add(coordinate);
            break;
          }
        }
        result.add(coordinate);
        newFile++;
        newRank--;
      } else {
        break;
      }
    }

    return result;
  }
}
