//

import 'package:jafraa_chess_app/features/game_pool.dart/domain/extensions/chess_piece_list_extension.dart';

import '../../../../core/domain/models/chess_coordinate.dart';
import '../../../../core/domain/models/file_notation.dart';
import '../../../../core/domain/models/chess_piece.dart';

class KnightMovesLocator {
  List<ChessCoordinate> locate(
    List<ChessPiece> board,
    ChessPiece piece, {
    bool includeSameColorPieces = false,
    required bool onlyRaw,
  }) {
    final List<ChessCoordinate> rawResult = [];
    final file = piece.coordinate.file.value;
    final rank = piece.coordinate.rank;

    // left north
    final leftNorthFile = file - 1;
    final leftNorthRank = rank + 2;
    if (board.isOnBoard(file: leftNorthFile, rank: leftNorthRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(leftNorthFile),
        rank: leftNorthRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);
      if (crossedPiece != null) {
        if (crossedPiece.color != piece.color) {
          rawResult.add(coordinate);
        } else {
          if (includeSameColorPieces) {
            rawResult.add(coordinate);
          }
        }
      } else {
        rawResult.add(coordinate);
      }
    }

    // left north west
    final leftNorthWestFile = file - 2;
    final leftNorthWestRank = rank + 1;
    if (board.isOnBoard(file: leftNorthWestFile, rank: leftNorthWestRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(leftNorthWestFile),
        rank: leftNorthWestRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);

      if (crossedPiece != null) {
        if (crossedPiece.color != piece.color) {
          rawResult.add(coordinate);
        } else {
          if (includeSameColorPieces) {
            rawResult.add(coordinate);
          }
        }
      } else {
        rawResult.add(coordinate);
      }
    }

    // left south west
    final leftSouthWestFile = file - 2;
    final leftSouthWestRank = rank - 1;
    if (board.isOnBoard(file: leftSouthWestFile, rank: leftSouthWestRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(leftSouthWestFile),
        rank: leftSouthWestRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);

      if (crossedPiece != null) {
        if (crossedPiece.color != piece.color) {
          rawResult.add(coordinate);
        } else {
          if (includeSameColorPieces) {
            rawResult.add(coordinate);
          }
        }
      } else {
        rawResult.add(coordinate);
      }
    }

    // left south
    final leftSouthFile = file - 1;
    final leftSouthRank = rank - 2;
    if (board.isOnBoard(file: leftSouthFile, rank: leftSouthRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(leftSouthFile),
        rank: leftSouthRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);

      if (crossedPiece != null) {
        if (crossedPiece.color != piece.color) {
          rawResult.add(coordinate);
        } else {
          if (includeSameColorPieces) {
            rawResult.add(coordinate);
          }
        }
      } else {
        rawResult.add(coordinate);
      }
    }

    // right north
    final rightNorthFile = file + 1;
    final rightNorthRank = rank + 2;
    if (board.isOnBoard(file: rightNorthFile, rank: rightNorthRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(rightNorthFile),
        rank: rightNorthRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);

      if (crossedPiece != null) {
        if (crossedPiece.color != piece.color) {
          rawResult.add(coordinate);
        } else {
          if (includeSameColorPieces) {
            rawResult.add(coordinate);
          }
        }
      } else {
        rawResult.add(coordinate);
      }
    }

    // right north east
    final rightNorthEastFile = file + 2;
    final rightNorthEastRank = rank + 1;
    if (board.isOnBoard(file: rightNorthEastFile, rank: rightNorthEastRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(rightNorthEastFile),
        rank: rightNorthEastRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);

      if (crossedPiece != null) {
        if (crossedPiece.color != piece.color) {
          rawResult.add(coordinate);
        } else {
          if (includeSameColorPieces) {
            rawResult.add(coordinate);
          }
        }
      } else {
        rawResult.add(coordinate);
      }
    }

    // right south east
    final rightSouthEastFile = file + 2;
    final rightSouthEastRank = rank - 1;
    if (board.isOnBoard(file: rightSouthEastFile, rank: rightSouthEastRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(rightSouthEastFile),
        rank: rightSouthEastRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);

      if (crossedPiece != null) {
        if (crossedPiece.color != piece.color) {
          rawResult.add(coordinate);
        } else {
          if (includeSameColorPieces) {
            rawResult.add(coordinate);
          }
        }
      } else {
        rawResult.add(coordinate);
      }
    }

    // right south
    final rightSouthFile = file + 1;
    final rightSouthRank = rank - 2;
    if (board.isOnBoard(file: rightSouthFile, rank: rightSouthRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(rightSouthFile),
        rank: rightSouthRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);

      if (crossedPiece != null) {
        if (crossedPiece.color != piece.color) {
          rawResult.add(coordinate);
        } else {
          if (includeSameColorPieces) {
            rawResult.add(coordinate);
          }
        }
      } else {
        rawResult.add(coordinate);
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
