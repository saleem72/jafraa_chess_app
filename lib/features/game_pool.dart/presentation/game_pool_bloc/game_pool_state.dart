// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'game_pool_bloc.dart';

class GamePoolState extends Equatable {
  const GamePoolState._({
    required this.pieces,
    required this.selectedPiece,
    required this.possibleMoves,
  });

  final List<ChessPiece> pieces;
  final ChessPiece? selectedPiece;
  final List<ChessCoordinate> possibleMoves;

  @override
  List<Object?> get props => [pieces, selectedPiece, possibleMoves];

  factory GamePoolState.initial() => GamePoolState._(
        pieces: ChessHelper.initialPieces(),
        selectedPiece: null,
        possibleMoves: const [],
      );

  GamePoolState copyWith({
    List<ChessPiece>? pieces,
    required ChessPiece? selectedPiece,
    List<ChessCoordinate>? possibleMoves,
  }) {
    return GamePoolState._(
      pieces: pieces ?? this.pieces,
      selectedPiece: selectedPiece,
      possibleMoves: possibleMoves ?? this.possibleMoves,
    );
  }
}
