//

import 'package:jafraa_chess_app/features/game_pool.dart/domain/extensions/chess_piece_list_extension.dart';

import '../../../../core/domain/models/chess_coordinate.dart';
import '../../../../core/domain/models/file_notation.dart';
import '../../../../core/domain/models/chess_piece.dart';

class RockMovesLocator {
  List<ChessCoordinate> locate(
    List<ChessPiece> board,
    ChessPiece piece, {
    bool includeSameColorPieces = false,
    required bool onlyRaw,
  }) {
    final List<ChessCoordinate> rawResult = [];
    final file = piece.coordinate.file.value;
    final rank = piece.coordinate.rank;
    int newFile = -1;
    int newRank = -1;
    // Vertical

    newFile = file;
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
              rawResult.add(coordinate);
            }
            break;
          } else {
            rawResult.add(coordinate);
            break;
          }
        }
        rawResult.add(coordinate);
        newRank--;
      } else {
        break;
      }
    }

    newFile = file;
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
              rawResult.add(coordinate);
            }
            break;
          } else {
            rawResult.add(coordinate);
            break;
          }
        }
        rawResult.add(coordinate);
        newRank++;
      } else {
        break;
      }
    }

    // Horizontal
    newFile = file - 1;
    newRank = rank;
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
              rawResult.add(coordinate);
            }
            break;
          } else {
            rawResult.add(coordinate);
            break;
          }
        }
        rawResult.add(coordinate);
        newFile--;
      } else {
        break;
      }
    }

    newFile = file + 1;
    newRank = rank;
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
              rawResult.add(coordinate);
            }
            break;
          } else {
            rawResult.add(coordinate);
            break;
          }
        }
        rawResult.add(coordinate);
        newFile++;
      } else {
        break;
      }
    }

    if (onlyRaw) {
      return rawResult;
    } else {
      final result = board.safeToKing(rawResult, piece);
      return result;
    }
  }
}
