//

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_notations.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/domain/helpers/chess_helper.dart';

import '../../../../core/domain/models/chess_coordinate.dart';
import '../../../../core/domain/models/chess_piece.dart';

part 'game_pool_event.dart';
part 'game_pool_state.dart';

class GamePoolBloc extends Bloc<GamePoolEvent, GamePoolState> {
  GamePoolBloc() : super(GamePoolState.initial()) {
    on<_SetSelected>(_onSetSelected);
    on<_ClearSelected>(_onClearSelected);
  }

  _onClearSelected(_ClearSelected event, Emitter<GamePoolState> emit) {
    emit(state.copyWith(selectedPiece: null, possibleMoves: []));
  }

  _onSetSelected(_SetSelected event, Emitter<GamePoolState> emit) {
    final possibleMoves = state.pieces.possibleMoves(event.piece);
    emit(state.copyWith(
        selectedPiece: event.piece, possibleMoves: possibleMoves));
  }
}
