// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'game_pool_bloc.dart';

class GamePoolState extends Equatable {
  const GamePoolState._({
    required this.pieces,
    required this.selectedPiece,
    required this.possibleMoves,
    required this.whiteDeadPieces,
    required this.blackDeadPieces,
    required this.whitePromote,
    required this.isBlackKingInThreate,
    required this.isWhiteKingInThreate,
  });

  final List<ChessPiece> pieces;
  final ChessPiece? selectedPiece;
  final List<ChessCoordinate> possibleMoves;
  final List<ChessPiece> whiteDeadPieces;
  final List<ChessPiece> blackDeadPieces;
  final bool whitePromote;
  final bool isWhiteKingInThreate;
  final bool isBlackKingInThreate;

  @override
  List<Object?> get props => [
        pieces,
        selectedPiece,
        possibleMoves,
        blackDeadPieces,
        whiteDeadPieces,
        whitePromote,
        isWhiteKingInThreate,
        isBlackKingInThreate,
      ];

  factory GamePoolState.initial() => GamePoolState._(
      pieces: ChessHelper.initialPieces(),
      selectedPiece: null,
      possibleMoves: const [],
      whiteDeadPieces: const [],
      blackDeadPieces: const [],
      whitePromote: false,
      isBlackKingInThreate: false,
      isWhiteKingInThreate: false);

  GamePoolState copyWith({
    List<ChessPiece>? pieces,
    required ChessPiece? selectedPiece,
    List<ChessCoordinate>? possibleMoves,
    List<ChessPiece>? whiteDeadPieces,
    List<ChessPiece>? blackDeadPieces,
    bool? whitePromote,
    bool? isBlackKingInThreate,
    bool? isWhiteKingInThreate,
  }) {
    return GamePoolState._(
      pieces: pieces ?? this.pieces,
      selectedPiece: selectedPiece,
      possibleMoves: possibleMoves ?? this.possibleMoves,
      whiteDeadPieces: whiteDeadPieces ?? this.whiteDeadPieces,
      blackDeadPieces: blackDeadPieces ?? this.blackDeadPieces,
      whitePromote: whitePromote ?? this.whitePromote,
      isBlackKingInThreate: isBlackKingInThreate ?? this.isBlackKingInThreate,
      isWhiteKingInThreate: isWhiteKingInThreate ?? this.isWhiteKingInThreate,
    );
  }
}
