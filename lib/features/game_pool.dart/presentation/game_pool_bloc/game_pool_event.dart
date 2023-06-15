// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'game_pool_bloc.dart';

abstract class GamePoolEvent extends Equatable {
  const GamePoolEvent();

  @override
  List<Object> get props => [];

  factory GamePoolEvent.setSelected({required ChessPiece piece}) =>
      _SetSelected(piece: piece);

  factory GamePoolEvent.clearSelected() => _ClearSelected();

  factory GamePoolEvent.squareTapped({required ChessCoordinate coordinate}) =>
      _SquareTapped(coordinate: coordinate);

  factory GamePoolEvent.normalMove({required ChessCoordinate coordinate}) =>
      _NormalMove(coordinate: coordinate);

  factory GamePoolEvent.whiteLongCastle() => _WhiteLongCastle();

  factory GamePoolEvent.whiteShortCastle() => _WhiteShortCastle();

  factory GamePoolEvent.blackLongCastle() => _BlackLongCastle();

  factory GamePoolEvent.blackShortCastle() => _BlackShortCastle();

  factory GamePoolEvent.inPassing({
    required ChessPiece piece,
    required ChessCoordinate coordinate,
  }) =>
      _InPassing(piece: piece, coordinate: coordinate);

  factory GamePoolEvent.setWhitePromotedPiece(
          {required PromotedPiece promotedPiece}) =>
      _SetWhitePromotedPiece(promotedPiece: promotedPiece);

  factory GamePoolEvent.setBlackPromotedPiece() => _SetBlackPromotedPiece();

  factory GamePoolEvent.resetBoard() => _ResetBoard();
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

class _SquareTapped extends GamePoolEvent {
  final ChessCoordinate coordinate;

  const _SquareTapped({
    required this.coordinate,
  });

  @override
  List<Object> get props => [coordinate];
}

class _NormalMove extends GamePoolEvent {
  final ChessCoordinate coordinate;

  const _NormalMove({
    required this.coordinate,
  });

  @override
  List<Object> get props => [coordinate];
}

class _WhiteLongCastle extends GamePoolEvent {}

class _WhiteShortCastle extends GamePoolEvent {}

class _BlackLongCastle extends GamePoolEvent {}

class _BlackShortCastle extends GamePoolEvent {}

class _InPassing extends GamePoolEvent {
  final ChessPiece piece;
  final ChessCoordinate coordinate;
  const _InPassing({
    required this.piece,
    required this.coordinate,
  });
  @override
  List<Object> get props => [piece, coordinate];
}

class _SetWhitePromotedPiece extends GamePoolEvent {
  final PromotedPiece promotedPiece;
  const _SetWhitePromotedPiece({
    required this.promotedPiece,
  });
  @override
  List<Object> get props => [promotedPiece];
}

class _SetBlackPromotedPiece extends GamePoolEvent {}

class _ResetBoard extends GamePoolEvent {}

class _KingsChecks extends GamePoolEvent {}
