// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'game_pool_bloc.dart';

abstract class GamePoolEvent extends Equatable {
  const GamePoolEvent();

  @override
  List<Object> get props => [];

  factory GamePoolEvent.setSelected({required ChessPiece piece}) =>
      _SetSelected(piece: piece);

  factory GamePoolEvent.clearSelected() => _ClearSelected();
}

class _SetSelected extends GamePoolEvent {
  final ChessPiece piece;

  const _SetSelected({
    required this.piece,
  });

  @override
  List<Object> get props => [piece];
}

class _ClearSelected extends GamePoolEvent {}
