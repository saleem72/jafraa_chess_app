//

import 'package:jafraa_chess_app/features/game_pool.dart/domain/extensions/chess_piece_list_extension.dart';

import '../../../../core/domain/models/chess_coordinate.dart';
import '../../../../core/domain/models/chess_notations.dart';
import '../../../../core/domain/models/chess_piece.dart';
import '../../../../core/domain/models/chess_piece_properties.dart';

class WhitePawnMovesLocator {
  List<ChessCoordinate> locate(
    List<ChessPiece> board,
    ChessPiece piece, {
    FileNotation? blackLastPawnTowSquares,
  }) {
    final List<ChessCoordinate> result = [];
    bool blocked = false;

    // one square
    final oneSquareFile = piece.coordinate.file.value;
    final oneSquareRank = piece.coordinate.rank + 1;
    if (board.isOnBoard(file: oneSquareFile, rank: oneSquareRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(oneSquareFile),
        rank: oneSquareRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);
      if (crossedPiece == null) {
        result.add(coordinate);
      } else {
        blocked = true;
      }
    }

    // kill other piece diagnally
    final rightKillFile = oneSquareFile + 1;
    final rightKillRank = oneSquareRank;
    if (board.isOnBoard(file: rightKillFile, rank: rightKillRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(rightKillFile),
        rank: rightKillRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);
      if (crossedPiece != null && crossedPiece.color == ChessPieceColor.black) {
        result.add(coordinate);
      }
    }

    // kill other piece diagnally
    final leftKillFile = oneSquareFile - 1;
    final leftKillRank = oneSquareRank;
    if (board.isOnBoard(file: leftKillFile, rank: leftKillRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(leftKillFile),
        rank: leftKillRank,
      );
      final crossedPiece = board.atCoordinates(coordinate);
      if (crossedPiece != null && crossedPiece.color == ChessPieceColor.black) {
        result.add(coordinate);
      }
    }
    if (piece.coordinate.rank == 5) {
      int inPassingFile = -1;
      final inPassingRank = piece.coordinate.rank + 1;
      if (blackLastPawnTowSquares?.value == piece.coordinate.file.value - 1) {
        inPassingFile = piece.coordinate.file.value - 1;
      } else if (blackLastPawnTowSquares?.value ==
          piece.coordinate.file.value + 1) {
        inPassingFile = piece.coordinate.file.value + 1;
      }

      if (inPassingFile != -1) {
        if (board.isOnBoard(
          file: inPassingFile,
          rank: inPassingRank,
        )) {
          final coordinate = ChessCoordinate(
            file: FileNotation.fromValue(inPassingFile),
            rank: inPassingRank,
          );
          result.add(coordinate);
        }
      }
    }

    if (blocked) {
      return result;
    }

    // tow squares
    if (piece.coordinate.rank == 2) {
      final towSquaresFile = piece.coordinate.file.value;
      final towSquaresRank = piece.coordinate.rank + 2;
      if (board.isOnBoard(file: towSquaresFile, rank: towSquaresRank)) {
        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(towSquaresFile),
          rank: towSquaresRank,
        );
        final crossedPiece = board.atCoordinates(coordinate);
        if (crossedPiece == null) {
          result.add(coordinate);
        }
      }
    }
    return result;
  }

  List<ChessCoordinate> supportedCoordinates(
      List<ChessPiece> board, ChessPiece piece) {
    final List<ChessCoordinate> result = [];

    // one square
    final oneSquareFile = piece.coordinate.file.value;
    final oneSquareRank = piece.coordinate.rank + 1;

    // kill other piece diagnally
    final rightKillFile = oneSquareFile + 1;
    final rightKillRank = oneSquareRank;
    if (board.isOnBoard(file: rightKillFile, rank: rightKillRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(rightKillFile),
        rank: rightKillRank,
      );
      result.add(coordinate);
    }

    // kill other piece diagnally
    final leftKillFile = oneSquareFile - 1;
    final leftKillRank = oneSquareRank;
    if (board.isOnBoard(file: leftKillFile, rank: leftKillRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(leftKillFile),
        rank: leftKillRank,
      );
      result.add(coordinate);
    }

    return result;
  }
}
