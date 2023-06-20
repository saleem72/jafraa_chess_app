//

import 'package:collection/collection.dart';
import 'package:jafraa_chess_app/core/domain/models/file_notation.dart';

import '../../../../core/domain/models/castling_rights.dart';
import '../../../../core/domain/models/chess_coordinate.dart';
import '../../../../core/domain/models/chess_piece.dart';
import '../../../../core/domain/models/chess_piece_properties.dart';
import '../helpers/chess_helper.dart';
import '../helpers/locators.dart';

extension ChessPieceList on List<ChessPiece> {
  ChessPiece? capablePiece(
    ChessPiece piece,
    ChessCoordinate coordinate, {
    CastlingRights? castlingRights,
  }) {
    final possiblePieces =
        where((e) => e.type == piece.type && e.color == piece.color).toList();

    // print(possiblePieces);

    if (possiblePieces.isNotEmpty) {
      final List<ChessPiece> whoCanDoIt = [];

      for (final possibility in possiblePieces) {
        final availableMoves =
            _validMoves(possibility, castlingRights: castlingRights);
        if (availableMoves.contains(coordinate)) {
          whoCanDoIt.add(possibility);
        }
      }

      if (whoCanDoIt.isEmpty) {
        return null;
      } else if (whoCanDoIt.length == 1) {
        return whoCanDoIt.first;
      } else {
        final temp = whoCanDoIt.firstWhereOrNull(
            (element) => element.coordinate.file == piece.coordinate.file);

        return temp;
      }
    } else {
      return null;
    }
  }

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

  List<ChessCoordinate> possibleMove(
    ChessPiece piece, {
    CastlingRights? castlingRights,
    FileNotation? whiteLastPawnTowSquares,
    FileNotation? blackLastPawnTowSquares,
  }) {
    return _validMoves(
      piece,
      castlingRights: castlingRights,
      whiteLastPawnTowSquares: whiteLastPawnTowSquares,
      blackLastPawnTowSquares: blackLastPawnTowSquares,
    );
  }

  List<ChessCoordinate> _validMoves(
    ChessPiece piece, {
    bool includeSameColorPieces = false,
    CastlingRights? castlingRights,
    FileNotation? whiteLastPawnTowSquares,
    FileNotation? blackLastPawnTowSquares,
    bool onlyRaw = false,
  }) {
    switch (piece.type) {
      case ChessPieceType.pawn:
        if (piece.color == ChessPieceColor.white) {
          return whitePawnMoves(
            piece,
            includeSameColorPieces: includeSameColorPieces,
            blackLastPawnTowSquares: blackLastPawnTowSquares,
            onlyRaw: onlyRaw,
          );
        } else {
          return blackPawnMoves(
            piece,
            includeSameColorPieces: includeSameColorPieces,
            whiteLastPawnTowSquares: whiteLastPawnTowSquares,
            onlyRaw: onlyRaw,
          );
        }
      case ChessPieceType.rock:
        return rockMoves(
          piece,
          includeSameColorPieces: includeSameColorPieces,
          onlyRaw: onlyRaw,
        );
      case ChessPieceType.knight:
        return knightMoves(
          piece,
          includeSameColorPieces: includeSameColorPieces,
          onlyRaw: onlyRaw,
        );
      case ChessPieceType.bishop:
        return bishopMoves(piece,
            includeSameColorPieces: includeSameColorPieces, onlyRaw: onlyRaw);
      case ChessPieceType.queen:
        return queenMoves(
          piece,
          includeSameColorPieces: includeSameColorPieces,
          onlyRaw: onlyRaw,
        );
      case ChessPieceType.king:
        return kingMoves(
          piece,
          includeSameColorPieces: includeSameColorPieces,
          castlingRights: castlingRights,
        );
    }
  }

  List<ChessCoordinate> whitePawnMoves(
    ChessPiece piece, {
    bool includeSameColorPieces = false,
    FileNotation? blackLastPawnTowSquares,
    required bool onlyRaw,
  }) {
    final locator = WhitePawnMovesLocator();
    if (includeSameColorPieces) {
      return locator.supportedCoordinates(this, piece);
    }
    return locator.locate(
      this,
      piece,
      blackLastPawnTowSquares: blackLastPawnTowSquares,
      onlyRaw: onlyRaw,
    );
  }

  List<ChessCoordinate> blackPawnMoves(
    ChessPiece piece, {
    bool includeSameColorPieces = false,
    FileNotation? whiteLastPawnTowSquares,
    required bool onlyRaw,
  }) {
    final locator = BlackPawnMovesLocator();
    if (includeSameColorPieces) {
      return locator.supportedCoordinates(this, piece);
    }
    return locator.locate(
      this,
      piece,
      whiteLastPawnTowSquares: whiteLastPawnTowSquares,
      onlyRaw: onlyRaw,
    );
  }

  List<ChessCoordinate> rockMoves(
    ChessPiece piece, {
    bool includeSameColorPieces = false,
    required bool onlyRaw,
  }) {
    final locator = RockMovesLocator();
    return locator.locate(
      this,
      piece,
      includeSameColorPieces: includeSameColorPieces,
      onlyRaw: onlyRaw,
    );
  }

  List<ChessCoordinate> knightMoves(
    ChessPiece piece, {
    bool includeSameColorPieces = false,
    required bool onlyRaw,
  }) {
    final locator = KnightMovesLocator();
    return locator.locate(this, piece,
        includeSameColorPieces: includeSameColorPieces, onlyRaw: onlyRaw);
  }

  List<ChessCoordinate> bishopMoves(
    ChessPiece piece, {
    bool includeSameColorPieces = false,
    required bool onlyRaw,
  }) {
    final locator = BishopMovesLocator();

    return locator.locate(this, piece,
        includeSameColorPieces: includeSameColorPieces, onlyRaw: onlyRaw);
  }

  List<ChessCoordinate> kingMoves(ChessPiece piece,
      {bool includeSameColorPieces = false, CastlingRights? castlingRights}) {
    final locator = KingMovesLocator();
    return locator.locate(
      this,
      piece,
      includeSameColorPieces: includeSameColorPieces,
      castlingRights: castlingRights,
    );
  }

  List<ChessCoordinate> queenMoves(
    ChessPiece piece, {
    bool includeSameColorPieces = false,
    required bool onlyRaw,
  }) {
    final locator = QueenMovesLocator();
    return locator.locate(
      this,
      piece,
      includeSameColorPieces: includeSameColorPieces,
      onlyRaw: onlyRaw,
    );
  }

  /// check if coordinates touched by another piece with cirten color
  /// coordinate
  /// color: pieces touch this coordinates should be have this color
  bool touchedByAnotherPiece(ChessCoordinate coordinate, ChessPieceColor color,
      {bool onlyRaw = true}) {
    final pieces = where((element) => element.color == color).toList();
    for (final piece in pieces) {
      final pieceOptions =
          _validMoves(piece, includeSameColorPieces: true, onlyRaw: onlyRaw);
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

  List<ChessCoordinate> safeToKing(
      List<ChessCoordinate> rawPossibilities, ChessPiece piece) {
    final king = firstWhere((element) =>
        element.type == ChessPieceType.king && element.color == piece.color);
    final List<ChessCoordinate> result = [];
    for (final coordinate in rawPossibilities) {
      List<ChessPiece> newBoard =
          map((e) => e == piece ? piece.moveTo(coordinate) : e).toList();

      final enemyPiece = atCoordinates(coordinate);
      newBoard = newBoard
          .map((e) => e == enemyPiece ? null : e)
          .whereType<ChessPiece>()
          .toList();
      if (!newBoard.touchedByAnotherPiece(king.coordinate, piece.color.opposite,
          onlyRaw: true)) {
        result.add(coordinate);
      }
    }
    return result;
  }
}
