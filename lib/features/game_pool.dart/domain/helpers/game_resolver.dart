//

import 'package:jafraa_chess_app/features/game_pool.dart/domain/extensions/chess_piece_list_extension.dart';

import '../../../../core/domain/models/castling_rights.dart';
import '../../../../core/domain/models/chess_coordinate.dart';
import '../../../../core/domain/models/chess_move.dart';
import '../../../../core/domain/models/chess_piece.dart';
import '../../../../core/domain/models/chess_piece_properties.dart';
import '../../../../core/domain/models/file_notation.dart';
import '../../../../core/domain/models/promoted_piece.dart';

class GameResolver {
  List<ChessPiece> _pieces = [];
  ChessPiece? _selectedPiece;
  List<ChessCoordinate> _possibleMoves = [];
  List<ChessPiece> _whiteDeadPieces = [];
  List<ChessPiece> _blackDeadPieces = [];
  bool whitePromote = false;
  bool isWhiteKingInThreate = false;
  bool isBlackKingInThreate = false;

  CastlingRights _whiteCastlingRights = CastlingRights.both;
  CastlingRights _blackCastlingRights = CastlingRights.both;
  FileNotation? _whiteLastPawnTowSquares;
  FileNotation? _blackLastPawnTowSquares;

  onSquareTapped(ChessCoordinate coordinate) {
    final piece = _pieces.atCoordinates(coordinate);
    // make move
    // first a piece was selected then new coordinates was selected
    if (_selectedPiece != null) {
      if (_possibleMoves.contains(coordinate)) {
        if (isItLongCasting(_selectedPiece!, coordinate)) {
          if (_selectedPiece!.color == ChessPieceColor.white) {
            _onWhiteLongCastle();
          } else {
            _onBlackLongCastle();
          }
          return;
        }

        if (isItShortCasting(_selectedPiece!, coordinate)) {
          if (_selectedPiece!.color == ChessPieceColor.white) {
            _onWhiteShortCastle();
          } else {
            _onBlackShortCastle();
          }
          return;
        }

        if (isItInPassing(_selectedPiece!, coordinate)) {
          _onInPassing(_selectedPiece!, coordinate);

          return;
        }

        if (isItPromotion(_selectedPiece!, coordinate)) {
          if (_selectedPiece?.color == ChessPieceColor.white) {
            whitePromote = true;
          } else {
            _onSetBlackPromotedPiece();
          }

          return;
        }
        _onNormalMove(coordinate);
        return;
      }
    }

    if (piece != null) {
      _onSetSelected(piece);
    } else {
      _onClearSelected();
    }
  }

  _onSetSelected(ChessPiece piece) {
    final castlingRights = piece.type == ChessPieceType.king
        ? piece.color == ChessPieceColor.white
            ? _whiteCastlingRights
            : _blackCastlingRights
        : null;
    final possibleMoves = _pieces.possibleMove(
      piece,
      castlingRights: castlingRights,
      whiteLastPawnTowSquares: _whiteLastPawnTowSquares,
      blackLastPawnTowSquares: _blackLastPawnTowSquares,
    );
    _selectedPiece = piece;
    _possibleMoves = possibleMoves;
  }

  _onClearSelected() {
    _selectedPiece = null;
    _possibleMoves = [];
  }

  _checkForPawnTowSquareMove(ChessPiece piece, ChessCoordinate coordinate) {
    if (piece.type == ChessPieceType.pawn) {
      final diff = coordinate.rank - piece.coordinate.rank;
      if (diff.abs() == 2) {
        // the move is pawn and 2 squares it can be 'in passing next move'
        if (piece.color == ChessPieceColor.white) {
          _whiteLastPawnTowSquares = piece.coordinate.file;
        } else {
          _blackLastPawnTowSquares = piece.coordinate.file;
        }
        return;
      }
    }
    if (piece.color == ChessPieceColor.white) {
      _whiteLastPawnTowSquares = null;
    } else {
      _blackLastPawnTowSquares = null;
    }
  }

  void _checkForRockMove(ChessPiece piece) {
    if (piece.type == ChessPieceType.rock) {
      if (piece.coordinate.rank == 1) {
        if (piece.coordinate.file == FileNotation.a) {
          // white left rock has moved
          _whiteCastlingRights = _whiteCastlingRights.disableLong();
        }
        if (piece.coordinate.file == FileNotation.h) {
          // white right rock has moved
          _whiteCastlingRights = _whiteCastlingRights.disableShort();
        }
      }
      if (piece.coordinate.rank == 7) {
        if (piece.coordinate.file == FileNotation.a) {
          // black left rock has moved
          _blackCastlingRights = _blackCastlingRights.disableLong();
        }
        if (piece.coordinate.file == FileNotation.h) {
          // black right rock has moved
          _blackCastlingRights = _blackCastlingRights.disableShort();
        }
      }
    }
  }

  void _checkForKingMove(ChessPiece piece) {
    if (piece.type == ChessPieceType.king) {
      if (piece.color == ChessPieceColor.white) {
        _whiteCastlingRights = CastlingRights.none;
      } else {
        _blackCastlingRights = CastlingRights.none;
      }
    }
  }

  List<ChessPiece> _internalMove(ChessPiece piece, ChessCoordinate coordinate,
      {bool doChecks = false}) {
    final crossPiece = _pieces.atCoordinates(coordinate);
    if (doChecks) {
      _checkForPawnTowSquareMove(piece, coordinate);
      _checkForRockMove(piece);
      _checkForKingMove(piece);
    }
    final newBoard = _pieces
        .map((e) => e == piece
            ? piece.moveTo(coordinate)
            : crossPiece == e
                ? null
                : e)
        .whereType<ChessPiece>()
        .toList();

    return newBoard;
  }

  _onNormalMove(ChessCoordinate coordinate) {
    final crossPiece = _pieces.atCoordinates(coordinate);

    final newBoard = _internalMove(_selectedPiece!, coordinate);

    _pieces = newBoard;
    _selectedPiece = null;
    _possibleMoves = [];

    if (crossPiece != null) {
      if (crossPiece.color == ChessPieceColor.white) {
        final newList = _whiteDeadPieces.map((e) => e).toList();
        newList.add(crossPiece);
        _selectedPiece = null;
        _whiteDeadPieces = newList;
      } else {
        final newList = _blackDeadPieces.map((e) => e).toList();
        newList.add(crossPiece);
        _selectedPiece = null;
        _blackDeadPieces = newList;
      }
    }
    _onKingsChecks();
  }

  _onInPassing(ChessPiece piece, ChessCoordinate coordinate) {
    final crossPieceRank = piece.color == ChessPieceColor.white
        ? coordinate.rank - 1
        : coordinate.rank + 1;

    final crossPieceCoordinate = ChessCoordinate(
      file: coordinate.file,
      rank: crossPieceRank,
    );

    final pawn = _pieces.atCoordinates(crossPieceCoordinate);

    final newBoard = _pieces
        .map((e) => e == _selectedPiece!
            ? _selectedPiece!.moveTo(coordinate)
            : pawn == e
                ? null
                : e)
        .whereType<ChessPiece>()
        .toList();

    _pieces = newBoard;
    _selectedPiece = null;
    _possibleMoves = [];

    if (pawn != null) {
      if (pawn.color == ChessPieceColor.white) {
        final newList = _whiteDeadPieces.map((e) => e).toList();
        newList.add(pawn);
        _selectedPiece = null;
        _whiteDeadPieces = newList;
      } else {
        final newList = _blackDeadPieces.map((e) => e).toList();
        newList.add(pawn);
        _selectedPiece = null;
        _blackDeadPieces = newList;
      }
    }
    _whiteLastPawnTowSquares = null;
    _blackLastPawnTowSquares = null;

    _onKingsChecks();
  }

  _onKingsChecks() {
    final whiteKing = _pieces.firstWhere((element) =>
        element.type == ChessPieceType.king &&
        element.color == ChessPieceColor.white);
    final blackKing = _pieces.firstWhere((element) =>
        element.type == ChessPieceType.king &&
        element.color == ChessPieceColor.black);

    final isWhiteKingInThreat = _pieces.inThreat(whiteKing);

    final isBlackKingInThreat = _pieces.inThreat(blackKing);

    isBlackKingInThreate = isBlackKingInThreat;
    isWhiteKingInThreate = isWhiteKingInThreat;
  }

  _onBlackLongCastle() {
    const rockCoordinates = ChessCoordinate(file: FileNotation.a, rank: 8);
    final rock = _pieces.atCoordinates(rockCoordinates);
    const kingCoordinates = ChessCoordinate(file: FileNotation.c, rank: 8);

    final king = _pieces.firstWhere((element) =>
        element.type == ChessPieceType.king &&
        element.color == ChessPieceColor.black);
    final newBoard = _pieces
        .map((e) => e == king
            ? king.moveTo(kingCoordinates)
            : rock == e
                ? rock!.moveTo(
                    const ChessCoordinate(file: FileNotation.d, rank: 8))
                : e)
        .whereType<ChessPiece>()
        .toList();
    _blackCastlingRights = CastlingRights.none;
    _whiteLastPawnTowSquares = null;
    _selectedPiece = null;
    _pieces = newBoard;
    _possibleMoves = [];
    _onKingsChecks();
  }

  _onBlackShortCastle() {
    const rockCoordinates = ChessCoordinate(file: FileNotation.h, rank: 8);
    final rock = _pieces.atCoordinates(rockCoordinates);
    const kingCoordinates = ChessCoordinate(file: FileNotation.g, rank: 8);
    final king = _pieces.firstWhere((element) =>
        element.type == ChessPieceType.king &&
        element.color == ChessPieceColor.black);
    final newBoard = _pieces
        .map((e) => e == king
            ? king.moveTo(kingCoordinates)
            : rock == e
                ? rock!.moveTo(
                    const ChessCoordinate(file: FileNotation.f, rank: 8))
                : e)
        .whereType<ChessPiece>()
        .toList();
    _blackCastlingRights = CastlingRights.none;
    _whiteLastPawnTowSquares = null;
    _selectedPiece = null;
    _pieces = newBoard;
    _possibleMoves = [];
    _onKingsChecks();
  }

  _onWhiteLongCastle() {
    const rockCoordinates = ChessCoordinate(file: FileNotation.a, rank: 1);
    final rock = _pieces.atCoordinates(rockCoordinates);
    const kingCoordinates = ChessCoordinate(file: FileNotation.c, rank: 1);
    final king = _pieces.firstWhere((element) =>
        element.type == ChessPieceType.king &&
        element.color == ChessPieceColor.white);
    final newBoard = _pieces
        .map((e) => e == king
            ? king.moveTo(kingCoordinates)
            : rock == e
                ? rock!.moveTo(
                    const ChessCoordinate(file: FileNotation.d, rank: 1))
                : e)
        .whereType<ChessPiece>()
        .toList();
    _whiteCastlingRights = CastlingRights.none;
    _whiteLastPawnTowSquares = null;
    _selectedPiece = null;
    _pieces = newBoard;
    _possibleMoves = [];
    _onKingsChecks();
  }

  _onWhiteShortCastle() {
    const rockCoordinates = ChessCoordinate(file: FileNotation.h, rank: 1);
    final rock = _pieces.atCoordinates(rockCoordinates);
    const kingCoordinates = ChessCoordinate(file: FileNotation.g, rank: 1);
    final king = _pieces.firstWhere((element) =>
        element.type == ChessPieceType.king &&
        element.color == ChessPieceColor.white);
    final newBoard = _pieces
        .map((e) => e == king
            ? king.moveTo(kingCoordinates)
            : rock == e
                ? rock!.moveTo(
                    const ChessCoordinate(file: FileNotation.f, rank: 1))
                : e)
        .whereType<ChessPiece>()
        .toList();
    _whiteCastlingRights = CastlingRights.none;
    _whiteLastPawnTowSquares = null;
    _selectedPiece = null;
    _pieces = newBoard;
    _possibleMoves = [];
    _onKingsChecks();
  }

  bool isItLongCasting(ChessPiece piece, ChessCoordinate coordinate) {
    if (piece.type == ChessPieceType.king) {
      // final diff = piece.coordinate.file.value - coordinate.file.value;
      if (coordinate.file == FileNotation.c) {
        return true;
      }
    }
    return false;
  }

  bool isItShortCasting(ChessPiece piece, ChessCoordinate coordinate) {
    if (piece.type == ChessPieceType.king) {
      // final diff = piece.coordinate.file.value - coordinate.file.value;
      if (coordinate.file == FileNotation.g) {
        return true;
      }
    }
    return false;
  }

  bool isItInPassing(ChessPiece piece, ChessCoordinate coordinate) {
    if (piece.type == ChessPieceType.pawn) {
      final passingRank = piece.color == ChessPieceColor.white ? 5 : 4;
      if (piece.coordinate.rank == passingRank) {
        final pawn = _pieces.atCoordinates(coordinate);
        if (pawn == null) {
          return true;
        }
      }
    }

    return false;
  }

  bool isItPromotion(ChessPiece piece, ChessCoordinate coordinate) {
    if (piece.type == ChessPieceType.pawn) {
      final passingRank = piece.color == ChessPieceColor.white ? 8 : 1;
      if (coordinate.rank == passingRank) {
        return true;
      }
    }

    return false;
  }

  /// Move from png
  _onMakeNormalMove(
    ChessPiece piece,
    ChessCoordinate coordinate,
  ) {
    final crossPiece = _pieces.atCoordinates(coordinate);

    final newBoard = _internalMove(piece, coordinate);

    _pieces = newBoard;
    _selectedPiece = null;
    _possibleMoves = [];

    if (crossPiece != null) {
      if (crossPiece.color == ChessPieceColor.white) {
        final newList = _whiteDeadPieces.map((e) => e).toList();
        newList.add(crossPiece);
        _selectedPiece = null;
        _whiteDeadPieces = newList;
      } else {
        final newList = _blackDeadPieces.map((e) => e).toList();
        newList.add(crossPiece);
        _selectedPiece = null;
        _blackDeadPieces = newList;
      }
    }
    _onKingsChecks();
  }

  _onDoMove(ChessMove move) {
    // print(move);
    if (move.type == null) {
      final target = ChessPiece.pawn(
        color: move.color,
        coordinate: move.file == null
            ? move.coordinate
            : ChessCoordinate(file: move.file!, rank: 1),
      );
      final pawn = _pieces.capablePiece(target, move.coordinate);
      if (pawn != null) {
        _onMakeNormalMove(pawn, move.coordinate);
      }
    } else if (move.type != null) {
      final target = ChessPiece(
          type: move.type!,
          color: move.color,
          coordinate: move.file == null
              ? move.coordinate
              : ChessCoordinate(file: move.file!, rank: 1));
      final piece = _pieces.capablePiece(
        target,
        move.coordinate,
        castlingRights: move.color == ChessPieceColor.white
            ? _whiteCastlingRights
            : _blackCastlingRights,
      );
      if (piece != null) {
        if (piece.type == ChessPieceType.king && move.isCastling) {
          if (move.color == ChessPieceColor.white) {
            if (move.coordinate.file == FileNotation.g) {
              _onWhiteShortCastle();
            } else if (move.coordinate.file == FileNotation.b) {
              _onWhiteLongCastle();
            }
          } else {
            if (move.coordinate.file == FileNotation.g) {
              _onBlackShortCastle();
            } else if (move.coordinate.file == FileNotation.b) {
              _onBlackLongCastle();
            }
          }
        } else {
          _onMakeNormalMove(piece, move.coordinate);
        }
      }
    }
  }

  /// Piece promotion

  _onSetBlackPromotedPiece() {
    if (_selectedPiece != null) {
      final piece = _selectedPiece!;
      if (piece.type == ChessPieceType.pawn &&
          piece.color == ChessPieceColor.black &&
          piece.coordinate.rank == 2) {
        final newCoordinate =
            ChessCoordinate(file: piece.coordinate.file, rank: 1);
        ChessPiece newPiece = ChessPiece.queen(
            color: ChessPieceColor.black, coordinate: newCoordinate);

        final newBoard = _pieces
            .map((e) => piece == e ? newPiece : e)
            .whereType<ChessPiece>()
            .toList();
        _selectedPiece = null;
        _possibleMoves = [];
        _pieces = newBoard;
        _blackLastPawnTowSquares = null;
        _onKingsChecks();
        return;
      }
    }
  }

  _onSetWhitePromotedPiece(PromotedPiece promotedPiece) {
    if (_selectedPiece != null) {
      final piece = _selectedPiece!;
      if (piece.type == ChessPieceType.pawn &&
          piece.color == ChessPieceColor.white &&
          piece.coordinate.rank == 7) {
        ChessPiece newPiece;
        final newCoordinate =
            ChessCoordinate(file: piece.coordinate.file, rank: 8);
        switch (promotedPiece) {
          case PromotedPiece.queen:
            newPiece = ChessPiece.queen(
                color: ChessPieceColor.white, coordinate: newCoordinate);
            break;
          case PromotedPiece.rock:
            newPiece = ChessPiece.rock(
                color: ChessPieceColor.white, coordinate: newCoordinate);
            break;
          case PromotedPiece.bishop:
            newPiece = ChessPiece.bishop(
                color: ChessPieceColor.white, coordinate: newCoordinate);
            break;
          case PromotedPiece.knight:
            newPiece = ChessPiece.knight(
                color: ChessPieceColor.white, coordinate: newCoordinate);
            break;
        }

        final newBoard = _pieces
            .map((e) => piece == e ? newPiece : e)
            .whereType<ChessPiece>()
            .toList();

        _selectedPiece = null;
        _possibleMoves = [];
        _pieces = newBoard;
        whitePromote = false;

        _whiteLastPawnTowSquares = null;
        _onKingsChecks();
        return;
      }
    }

    whitePromote = false;
  }
}
