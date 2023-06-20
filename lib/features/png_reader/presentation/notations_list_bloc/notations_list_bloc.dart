//

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/models/chess_game.dart';
import '../../../../core/domain/models/chess_move.dart';
import '../../../../core/domain/models/chess_piece_properties.dart';

part 'notations_list_event.dart';
part 'notations_list_state.dart';

class NotationsListBloc extends Bloc<NotationsListEvent, NotationsListState> {
  NotationsListBloc({required ChessGame game})
      : super(NotationsListState.initial(game: game)) {
    on<_SetSelected>(_onSetSelected);
    on<_ClearSelected>(_onClearSelected);
  }
  _onClearSelected(_ClearSelected event, Emitter<NotationsListState> emit) {
    emit(state.copyWith(selectedMove: -1));
  }

  _onSetSelected(_SetSelected event, Emitter<NotationsListState> emit) {
    emit(state.copyWith(selectedMove: event.index));
  }

  ChessMove? nextMove() {
    final selectedIndex = state.selectedMove;
    if (selectedIndex < state.moves.length - 1) {
      final move = state.moves[selectedIndex + 1];

      add(_SetSelected(index: selectedIndex + 1));
      return move;
    }
    return null;
  }

  double offsetFor(ChessMove move) {
    // white 68
    // black 40
    const double whiteSize = 68;
    const double blackSize = 40;
    final double percentage = (move.number - 5) ~/ 10 * 3;
    // final int total = state.moves.length;
    final double previous = (move.number - 1) * (whiteSize + blackSize);
    // if (move.color == ChessPieceColor.white) {
    //   return previous + (whiteSize * percentage); //  * move.number / total
    // } else {
    //   return previous + whiteSize +  (blackSize * percentage); //  * move.number / total
    // }
    return previous + (whiteSize * percentage);
  }
}
