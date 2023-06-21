//

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jafraa_chess_app/core/domain/models/castling_rights.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_piece_properties.dart';
import 'package:jafraa_chess_app/core/domain/models/promoted_piece.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/domain/extensions/chess_piece_list_extension.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/domain/helpers/chess_helper.dart';

import '../../../../core/domain/models/chess_coordinate.dart';
import '../../../../core/domain/models/chess_move.dart';
import '../../../../core/domain/models/file_notation.dart';
import '../../../../core/domain/models/chess_piece.dart';
import '../../domain/helpers/game_resolver.dart';

part 'game_pool_event.dart';
part 'game_pool_state.dart';

class GamePoolBloc extends Bloc<GamePoolEvent, GamePoolState> {
  // TODO: check for king safty when castling;

  GamePoolBloc() : super(GamePoolState.initial()) {
    on<_SquareTapped>(_onSquareTapped);
    on<_SetWhitePromotedPiece>(_onSetWhitePromotedPiece);
    on<_DoMove>(_onDoMove);
    on<_ResetBoard>(_onResetBoard);
  }

  CastlingRights whiteCastlingRights = CastlingRights.both;
  CastlingRights blackCastlingRights = CastlingRights.both;
  FileNotation? whiteLastPawnTowSquares;
  FileNotation? blackLastPawnTowSquares;

  final GameResolver resolver = GameResolver();

  _onDoMove(_DoMove event, Emitter<GamePoolState> emit) {
    resolver.onDoMove(event.move);
    emit(resolver.toState());
  }

  _onResetBoard(_ResetBoard event, Emitter<GamePoolState> emit) {
    resolver.onResetBoard();
    emit(resolver.toState());
  }

  _onSetWhitePromotedPiece(
      _SetWhitePromotedPiece event, Emitter<GamePoolState> emit) {
    resolver.onSetWhitePromotedPiece(event.promotedPiece);
    emit(resolver.toState());
  }

  _onSquareTapped(_SquareTapped event, Emitter<GamePoolState> emit) {
    resolver.onSquareTapped(event.coordinate);
    emit(resolver.toState());
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
