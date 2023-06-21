// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'game_pool_bloc.dart';

abstract class GamePoolEvent extends Equatable {
  const GamePoolEvent();

  @override
  List<Object> get props => [];

  factory GamePoolEvent.squareTapped({required ChessCoordinate coordinate}) =>
      _SquareTapped(coordinate: coordinate);

  factory GamePoolEvent.setWhitePromotedPiece(
          {required PromotedPiece promotedPiece}) =>
      _SetWhitePromotedPiece(promotedPiece: promotedPiece);

  factory GamePoolEvent.doMove({required ChessMove move}) =>
      _DoMove(move: move);

  factory GamePoolEvent.resetBoard() => _ResetBoard();
}

class _SquareTapped extends GamePoolEvent {
  final ChessCoordinate coordinate;

  const _SquareTapped({
    required this.coordinate,
  });

  @override
  List<Object> get props => [coordinate];
}

class _SetWhitePromotedPiece extends GamePoolEvent {
  final PromotedPiece promotedPiece;
  const _SetWhitePromotedPiece({
    required this.promotedPiece,
  });
  @override
  List<Object> get props => [promotedPiece];
}

class _ResetBoard extends GamePoolEvent {}

class _DoMove extends GamePoolEvent {
  final ChessMove move;
  const _DoMove({
    required this.move,
  });

  @override
  List<Object> get props => [move];
}
