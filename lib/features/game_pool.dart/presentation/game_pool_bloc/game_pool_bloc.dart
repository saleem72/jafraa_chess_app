//

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_piece_properties.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/domain/extensions/chess_piece_list_extension.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/domain/helpers/chess_helper.dart';

import '../../../../core/domain/models/chess_coordinate.dart';
import '../../../../core/domain/models/chess_piece.dart';

part 'game_pool_event.dart';
part 'game_pool_state.dart';

class GamePoolBloc extends Bloc<GamePoolEvent, GamePoolState> {
  GamePoolBloc() : super(GamePoolState.initial()) {
    on<_SetSelected>(_onSetSelected);
    on<_ClearSelected>(_onClearSelected);
    on<_SquareTapped>(_onSquareTapped);
  }

  _onSquareTapped(_SquareTapped event, Emitter<GamePoolState> emit) {
    final piece = state.pieces.atCoordinates(event.coordinate);
    // make move
    // first a piece was selected then new coordinates was selected
    // TODO: promoting
    if (state.selectedPiece != null &&
        state.possibleMoves.contains(event.coordinate)) {
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
      return;
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
    final possibleMoves = state.pieces.possibleMove(event.piece);
    emit(state.copyWith(
        selectedPiece: event.piece, possibleMoves: possibleMoves));
  }
}
