//

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jafraa_chess_app/core/domain/models/castling_rights.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_piece_properties.dart';
import 'package:jafraa_chess_app/core/domain/models/promoted_piece.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/domain/extensions/chess_piece_list_extension.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/domain/helpers/chess_helper.dart';

import '../../../../core/domain/models/chess_coordinate.dart';
import '../../../../core/domain/models/file_notation.dart';
import '../../../../core/domain/models/chess_piece.dart';

part 'game_pool_event.dart';
part 'game_pool_state.dart';

class GamePoolBloc extends Bloc<GamePoolEvent, GamePoolState> {
  // TODO: check for king safty when castling;

  GamePoolBloc() : super(GamePoolState.initial()) {
    on<_SetSelected>(_onSetSelected);
    on<_ClearSelected>(_onClearSelected);
    on<_SquareTapped>(_onSquareTapped);
    on<_WhiteLongCastle>(_onWhiteLongCastle);
    on<_WhiteShortCastle>(_onWhiteShortCastle);
    on<_BlackLongCastle>(_onBlackLongCastle);
    on<_BlackShortCastle>(_onBlackShortCastle);
    on<_NormalMove>(_onNormalMove);
    on<_InPassing>(_onInPassing);
    on<_SetWhitePromotedPiece>(_onSetWhitePromotedPiece);
    on<_SetBlackPromotedPiece>(_onSetBlackPromotedPiece);
    on<_ResetBoard>(_onResetBoard);
    on<_KingsChecks>(_onKingsChecks);
  }

  CastlingRights whiteCastlingRights = CastlingRights.both;
  CastlingRights blackCastlingRights = CastlingRights.both;
  FileNotation? whiteLastPawnTowSquares;
  FileNotation? blackLastPawnTowSquares;

  _onKingsChecks(_KingsChecks event, Emitter<GamePoolState> emit) {
    final whiteKing = state.pieces.firstWhere((element) =>
        element.type == ChessPieceType.king &&
        element.color == ChessPieceColor.white);
    final blackKing = state.pieces.firstWhere((element) =>
        element.type == ChessPieceType.king &&
        element.color == ChessPieceColor.black);

    final isWhiteKingInThreat = state.pieces.inThreat(whiteKing);

    final isBlackKingInThreat = state.pieces.inThreat(blackKing);

    emit(
      state.copyWith(
        selectedPiece: state.selectedPiece,
        isBlackKingInThreate: isBlackKingInThreat,
        isWhiteKingInThreate: isWhiteKingInThreat,
      ),
    );
  }

  _onResetBoard(_ResetBoard event, Emitter<GamePoolState> emit) {
    whiteCastlingRights = CastlingRights.both;
    blackCastlingRights = CastlingRights.both;

    whiteLastPawnTowSquares = null;
    blackLastPawnTowSquares = null;

    emit(
      GamePoolState.initial(),
    );
  }

  _onSetBlackPromotedPiece(
      _SetBlackPromotedPiece event, Emitter<GamePoolState> emit) {
    if (state.selectedPiece != null) {
      final piece = state.selectedPiece!;
      if (piece.type == ChessPieceType.pawn &&
          piece.color == ChessPieceColor.black &&
          piece.coordinate.rank == 2) {
        final newCoordinate =
            ChessCoordinate(file: piece.coordinate.file, rank: 1);
        ChessPiece newPiece = ChessPiece.queen(
            color: ChessPieceColor.black, coordinate: newCoordinate);

        final newBoard = state.pieces
            .map((e) => piece == e ? newPiece : e)
            .whereType<ChessPiece>()
            .toList();
        emit(
          state.copyWith(
            selectedPiece: null,
            possibleMoves: [],
            pieces: newBoard,
          ),
        );
        blackLastPawnTowSquares = null;
        add(_KingsChecks());
        return;
      }
    }
  }

  _onSetWhitePromotedPiece(
      _SetWhitePromotedPiece event, Emitter<GamePoolState> emit) {
    if (state.selectedPiece != null) {
      final piece = state.selectedPiece!;
      if (piece.type == ChessPieceType.pawn &&
          piece.color == ChessPieceColor.white &&
          piece.coordinate.rank == 7) {
        ChessPiece newPiece;
        final newCoordinate =
            ChessCoordinate(file: piece.coordinate.file, rank: 8);
        switch (event.promotedPiece) {
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

        final newBoard = state.pieces
            .map((e) => piece == e ? newPiece : e)
            .whereType<ChessPiece>()
            .toList();
        emit(
          state.copyWith(
            selectedPiece: null,
            possibleMoves: [],
            pieces: newBoard,
            whitePromote: false,
          ),
        );
        whiteLastPawnTowSquares = null;
        add(_KingsChecks());
        return;
      }
    }

    emit(
      state.copyWith(
        selectedPiece: state.selectedPiece,
        whitePromote: false,
      ),
    );
  }

  _onInPassing(_InPassing event, Emitter<GamePoolState> emit) {
    final crossPieceRank = event.piece.color == ChessPieceColor.white
        ? event.coordinate.rank - 1
        : event.coordinate.rank + 1;

    final crossPieceCoordinate = ChessCoordinate(
      file: event.coordinate.file,
      rank: crossPieceRank,
    );

    final pawn = state.pieces.atCoordinates(crossPieceCoordinate);

    final newBoard = state.pieces
        .map((e) => e == state.selectedPiece!
            ? state.selectedPiece!.moveTo(event.coordinate)
            : pawn == e
                ? null
                : e)
        .whereType<ChessPiece>()
        .toList();

    emit(
      state.copyWith(
        pieces: newBoard,
        selectedPiece: null,
        possibleMoves: [],
      ),
    );

    if (pawn != null) {
      if (pawn.color == ChessPieceColor.white) {
        final newList = state.whiteDeadPieces.map((e) => e).toList();
        newList.add(pawn);
        emit(state.copyWith(
          selectedPiece: null,
          whiteDeadPieces: newList,
        ));
      } else {
        final newList = state.blackDeadPieces.map((e) => e).toList();
        newList.add(pawn);
        emit(state.copyWith(
          selectedPiece: null,
          blackDeadPieces: newList,
        ));
      }
    }
    whiteLastPawnTowSquares = null;
    blackLastPawnTowSquares = null;

    add(_KingsChecks());
  }

  _onNormalMove(_NormalMove event, Emitter<GamePoolState> emit) {
    final piece = state.pieces.atCoordinates(event.coordinate);
    _checkForPawnTowSquareMove(state.selectedPiece!, event.coordinate);
    _checkForRockMove(state.selectedPiece!);
    _checkForKingMove(state.selectedPiece!);
    final newBoard = state.pieces
        .map((e) => e == state.selectedPiece!
            ? state.selectedPiece!.moveTo(event.coordinate)
            : piece == e
                ? null
                : e)
        .whereType<ChessPiece>()
        .toList();

    emit(
      state.copyWith(
        pieces: newBoard,
        selectedPiece: null,
        possibleMoves: [],
      ),
    );

    if (piece != null) {
      if (piece.color == ChessPieceColor.white) {
        final newList = state.whiteDeadPieces.map((e) => e).toList();
        newList.add(piece);
        emit(state.copyWith(
          selectedPiece: null,
          whiteDeadPieces: newList,
        ));
      } else {
        final newList = state.blackDeadPieces.map((e) => e).toList();
        newList.add(piece);
        emit(state.copyWith(
          selectedPiece: null,
          blackDeadPieces: newList,
        ));
      }
    }
    add(_KingsChecks());
  }

  _onBlackLongCastle(_BlackLongCastle event, Emitter<GamePoolState> emit) {
    const rockCoordinates = ChessCoordinate(file: FileNotation.a, rank: 8);
    final rock = state.pieces.atCoordinates(rockCoordinates);
    const kingCoordinates = ChessCoordinate(file: FileNotation.c, rank: 8);
    final newBoard = state.pieces
        .map((e) => e == state.selectedPiece!
            ? state.selectedPiece!.moveTo(kingCoordinates)
            : rock == e
                ? rock!.moveTo(
                    const ChessCoordinate(file: FileNotation.d, rank: 8))
                : e)
        .whereType<ChessPiece>()
        .toList();
    whiteCastlingRights = CastlingRights.none;
    whiteLastPawnTowSquares = null;
    emit(
      state.copyWith(
        selectedPiece: null,
        pieces: newBoard,
        possibleMoves: [],
      ),
    );
    add(_KingsChecks());
  }

  _onBlackShortCastle(_BlackShortCastle event, Emitter<GamePoolState> emit) {
    const rockCoordinates = ChessCoordinate(file: FileNotation.h, rank: 8);
    final rock = state.pieces.atCoordinates(rockCoordinates);
    const kingCoordinates = ChessCoordinate(file: FileNotation.g, rank: 8);
    final newBoard = state.pieces
        .map((e) => e == state.selectedPiece!
            ? state.selectedPiece!.moveTo(kingCoordinates)
            : rock == e
                ? rock!.moveTo(
                    const ChessCoordinate(file: FileNotation.f, rank: 8))
                : e)
        .whereType<ChessPiece>()
        .toList();
    whiteCastlingRights = CastlingRights.none;
    whiteLastPawnTowSquares = null;
    emit(
      state.copyWith(
        selectedPiece: null,
        pieces: newBoard,
        possibleMoves: [],
      ),
    );
    add(_KingsChecks());
  }

  _onWhiteLongCastle(_WhiteLongCastle event, Emitter<GamePoolState> emit) {
    const rockCoordinates = ChessCoordinate(file: FileNotation.a, rank: 1);
    final rock = state.pieces.atCoordinates(rockCoordinates);
    const kingCoordinates = ChessCoordinate(file: FileNotation.c, rank: 1);
    final newBoard = state.pieces
        .map((e) => e == state.selectedPiece!
            ? state.selectedPiece!.moveTo(kingCoordinates)
            : rock == e
                ? rock!.moveTo(
                    const ChessCoordinate(file: FileNotation.d, rank: 1))
                : e)
        .whereType<ChessPiece>()
        .toList();
    whiteCastlingRights = CastlingRights.none;
    whiteLastPawnTowSquares = null;
    emit(
      state.copyWith(
        selectedPiece: null,
        pieces: newBoard,
        possibleMoves: [],
      ),
    );
    add(_KingsChecks());
  }

  _onWhiteShortCastle(_WhiteShortCastle event, Emitter<GamePoolState> emit) {
    const rockCoordinates = ChessCoordinate(file: FileNotation.h, rank: 1);
    final rock = state.pieces.atCoordinates(rockCoordinates);
    const kingCoordinates = ChessCoordinate(file: FileNotation.g, rank: 1);
    final newBoard = state.pieces
        .map((e) => e == state.selectedPiece!
            ? state.selectedPiece!.moveTo(kingCoordinates)
            : rock == e
                ? rock!.moveTo(
                    const ChessCoordinate(file: FileNotation.f, rank: 1))
                : e)
        .whereType<ChessPiece>()
        .toList();
    whiteCastlingRights = CastlingRights.none;
    whiteLastPawnTowSquares = null;
    emit(
      state.copyWith(
        selectedPiece: null,
        pieces: newBoard,
        possibleMoves: [],
      ),
    );
    add(_KingsChecks());
  }

  _onSquareTapped(_SquareTapped event, Emitter<GamePoolState> emit) {
    final piece = state.pieces.atCoordinates(event.coordinate);
    // make move
    // first a piece was selected then new coordinates was selected
    if (state.selectedPiece != null) {
      if (state.possibleMoves.contains(event.coordinate)) {
        if (isItLongCasting(state.selectedPiece!, event.coordinate)) {
          if (state.selectedPiece!.color == ChessPieceColor.white) {
            add(GamePoolEvent.whiteLongCastle());
          } else {
            add(GamePoolEvent.blackLongCastle());
          }
          return;
        }

        if (isItShortCasting(state.selectedPiece!, event.coordinate)) {
          if (state.selectedPiece!.color == ChessPieceColor.white) {
            add(GamePoolEvent.whiteShortCastle());
          } else {
            add(GamePoolEvent.blackShortCastle());
          }
          return;
        }

        if (isItInPassing(state.selectedPiece!, event.coordinate)) {
          add(
            GamePoolEvent.inPassing(
              piece: state.selectedPiece!,
              coordinate: event.coordinate,
            ),
          );
          return;
        }

        if (isItPromotion(state.selectedPiece!, event.coordinate)) {
          if (state.selectedPiece?.color == ChessPieceColor.white) {
            emit(
              state.copyWith(
                selectedPiece: state.selectedPiece,
                whitePromote: true,
              ),
            );
          } else {
            add(GamePoolEvent.setBlackPromotedPiece());
          }

          return;
        }

        add(GamePoolEvent.normalMove(coordinate: event.coordinate));
        return;
      }
    }

    if (piece != null) {
      add(_SetSelected(piece: piece));
    } else {
      add(_ClearSelected());
    }
  }

  _onClearSelected(_ClearSelected event, Emitter<GamePoolState> emit) {
    emit(state.copyWith(selectedPiece: null, possibleMoves: []));
  }

  _onSetSelected(_SetSelected event, Emitter<GamePoolState> emit) {
    final castlingRights = event.piece.type == ChessPieceType.king
        ? event.piece.color == ChessPieceColor.white
            ? whiteCastlingRights
            : blackCastlingRights
        : null;
    final possibleMoves = state.pieces.possibleMove(
      event.piece,
      castlingRights: castlingRights,
      whiteLastPawnTowSquares: whiteLastPawnTowSquares,
      blackLastPawnTowSquares: blackLastPawnTowSquares,
    );
    emit(state.copyWith(
        selectedPiece: event.piece, possibleMoves: possibleMoves));
  }

  _checkForPawnTowSquareMove(ChessPiece piece, ChessCoordinate coordinate) {
    if (piece.type == ChessPieceType.pawn) {
      final diff = coordinate.rank - piece.coordinate.rank;
      if (diff.abs() == 2) {
        // the move is pawn and 2 squares it can be 'in passing next move'
        if (piece.color == ChessPieceColor.white) {
          whiteLastPawnTowSquares = piece.coordinate.file;
        } else {
          blackLastPawnTowSquares = piece.coordinate.file;
        }
        return;
      }
    }
    if (piece.color == ChessPieceColor.white) {
      whiteLastPawnTowSquares = null;
    } else {
      blackLastPawnTowSquares = null;
    }
  }

  void _checkForRockMove(ChessPiece piece) {
    if (piece.type == ChessPieceType.rock) {
      if (piece.coordinate.rank == 1) {
        if (piece.coordinate.file == FileNotation.a) {
          // white left rock has moved
          whiteCastlingRights = whiteCastlingRights.disableLong();
        }
        if (piece.coordinate.file == FileNotation.h) {
          // white right rock has moved
          whiteCastlingRights = whiteCastlingRights.disableShort();
        }
      }
      if (piece.coordinate.rank == 7) {
        if (piece.coordinate.file == FileNotation.a) {
          // black left rock has moved
          blackCastlingRights = blackCastlingRights.disableLong();
        }
        if (piece.coordinate.file == FileNotation.h) {
          // black right rock has moved
          blackCastlingRights = blackCastlingRights.disableShort();
        }
      }
    }
  }

  void _checkForKingMove(ChessPiece piece) {
    if (piece.type == ChessPieceType.king) {
      if (piece.color == ChessPieceColor.white) {
        whiteCastlingRights = CastlingRights.none;
      } else {
        blackCastlingRights = CastlingRights.none;
      }
    }
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
        final pawn = state.pieces.atCoordinates(coordinate);
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
}
