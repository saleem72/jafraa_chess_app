//

import 'package:collection/collection.dart';

import '../../../../core/domain/models/chess_coordinate.dart';
import '../../../../core/domain/models/chess_piece.dart';
import '../../../../core/domain/models/chess_piece_properties.dart';
import '../helpers/chess_helper.dart';
import '../helpers/locators.dart';

extension ChessPieceList on List<ChessPiece> {
  ChessPiece? atIndex(int index) {
    final coordinate = ChessHelper.getCoordinate(index);

    return firstWhereOrNull((element) => element.coordinate == coordinate);
  }

  ChessPiece? atCoordinates(ChessCoordinate coordinate) {
    return firstWhereOrNull((element) => element.coordinate == coordinate);
  }

  bool isOnBoard({required int file, required int rank}) {
    return file >= 0 && file < 8 && rank >= 1 && rank < 9;
  }

  List<ChessCoordinate> possibleMove(ChessPiece piece,
      {bool includeSameColorPieces = false}) {
    switch (piece.type) {
      case ChessPieceType.pawn:
        if (piece.color == ChessPieceColor.white) {
          return whitePawnMoves(piece,
              includeSameColorPieces: includeSameColorPieces);
        } else {
          return blackPawnMoves(piece,
              includeSameColorPieces: includeSameColorPieces);
        }
      case ChessPieceType.rock:
        return rockMoves(piece, includeSameColorPieces: includeSameColorPieces);
      case ChessPieceType.knight:
        return knightMoves(piece,
            includeSameColorPieces: includeSameColorPieces);
      case ChessPieceType.bishop:
        return bishopMoves(piece,
            includeSameColorPieces: includeSameColorPieces);
      case ChessPieceType.queen:
        return queenMoves(piece,
            includeSameColorPieces: includeSameColorPieces);
      case ChessPieceType.king:
        return kingMoves(piece, includeSameColorPieces: includeSameColorPieces);
    }
  }

  List<ChessCoordinate> whitePawnMoves(ChessPiece piece,
      {bool includeSameColorPieces = false}) {
    final locator = WhitePawnMovesLocator();
    if (includeSameColorPieces) {
      return locator.supportedCoordinates(this, piece);
    }
    return locator.locate(this, piece);
  }

  List<ChessCoordinate> blackPawnMoves(ChessPiece piece,
      {bool includeSameColorPieces = false}) {
    final locator = BlackPawnMovesLocator();
    if (includeSameColorPieces) {
      return locator.supportedCoordinates(this, piece);
    }
    return locator.locate(this, piece);
  }

  List<ChessCoordinate> rockMoves(ChessPiece piece,
      {bool includeSameColorPieces = false}) {
    final locator = RockMovesLocator();
    return locator.locate(this, piece,
        includeSameColorPieces: includeSameColorPieces);
  }

  List<ChessCoordinate> knightMoves(ChessPiece piece,
      {bool includeSameColorPieces = false}) {
    final locator = KnightMovesLocator();
    return locator.locate(this, piece,
        includeSameColorPieces: includeSameColorPieces);
  }

  List<ChessCoordinate> bishopMoves(ChessPiece piece,
      {bool includeSameColorPieces = false}) {
    final locator = BishopMovesLocator();

    return locator.locate(this, piece,
        includeSameColorPieces: includeSameColorPieces);
  }

  List<ChessCoordinate> kingMoves(ChessPiece piece,
      {bool includeSameColorPieces = false}) {
    final locator = KingMovesLocator();
    return locator.locate(this, piece,
        includeSameColorPieces: includeSameColorPieces);
  }

  List<ChessCoordinate> queenMoves(ChessPiece piece,
      {bool includeSameColorPieces = false}) {
    final locator = QueenMovesLocator();
    return locator.locate(this, piece,
        includeSameColorPieces: includeSameColorPieces);
  }

  /// check if coordinates touched by another piece with cirten color
  /// coordinate
  /// color: pieces touch this coordinates should be have this color
  bool touchedByAnotherPiece(
      ChessCoordinate coordinate, ChessPieceColor color) {
    final pieces = where((element) => element.color == color).toList();
    for (final piece in pieces) {
      final pieceOptions = possibleMove(piece, includeSameColorPieces: true);
      if (pieceOptions.contains(coordinate)) {
        return true;
      }
    }
    return false;
  }

  bool isPieceProtected(ChessPiece piece) {
    return touchedByAnotherPiece(piece.coordinate, piece.color);
  }

  bool inThreat(ChessPiece piece) {
    return touchedByAnotherPiece(piece.coordinate, piece.color.opposite);
  }

  List<ChessPiece> movePieceTo(
      {required ChessPiece piece, required ChessCoordinate coordinate}) {
    final newBoard = map((e) => e == piece ? piece.moveTo(coordinate) : e)
        .whereType<ChessPiece>()
        .toList();
    return newBoard;
  }
}
