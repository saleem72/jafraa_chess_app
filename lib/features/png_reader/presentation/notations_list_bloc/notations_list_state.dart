// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'notations_list_bloc.dart';

class NotationsListState extends Equatable {
  const NotationsListState({
    required this.game,
    required this.moves,
    required this.selectedMove,
  });

  final ChessGame game;
  final List<ChessMove> moves;
  final int selectedMove;

  @override
  List<Object> get props => [game, moves, selectedMove];

  factory NotationsListState.initial({required ChessGame game}) {
    // final List<ChessMove> list = game.notations.map((e) => ChessMove.fromNotation(notation: e.whiteMove, number: number, color: color)).toList();
    final List<ChessMove> list = [];

    for (final notation in game.notations) {
      final white = ChessMove.fromNotation(
        notation: notation.whiteMove,
        number: notation.number,
        color: ChessPieceColor.white,
      );
      final black = ChessMove.fromNotation(
        notation: notation.blackMove,
        number: notation.number,
        color: ChessPieceColor.black,
      );
      list.add(white);
      list.add(black);
    }
    return NotationsListState(game: game, moves: list, selectedMove: -1);
  }

  NotationsListState copyWith({
    int? selectedMove,
  }) {
    return NotationsListState(
      game: game,
      moves: moves,
      selectedMove: selectedMove ?? this.selectedMove,
    );
  }
}
