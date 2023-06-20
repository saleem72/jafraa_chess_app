// ignore_for_file: public_member_api_docs, sort_constructors_first
//

import 'package:equatable/equatable.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_piece_properties.dart';

import 'chess_coordinate.dart';
import 'file_notation.dart';
import 'notation_move.dart';

class ChessMove extends Equatable {
  final String line;
  final int number;
  final ChessPieceType? type;
  final FileNotation? file;
  final ChessCoordinate coordinate;
  final ChessPieceColor color;
  final bool isCastling;

  @override
  List<Object?> get props => [
        line,
        number,
        type,
        file,
        coordinate,
        color,
        isCastling,
      ];

  const ChessMove({
    required this.line,
    required this.number,
    this.type,
    this.file,
    required this.coordinate,
    required this.color,
    required this.isCastling,
  });

  factory ChessMove.fromNotation({
    required NotationMove notation,
    required int number,
    required ChessPieceColor color,
  }) {
    return ChessMove(
      line: notation.line,
      number: number,
      coordinate: notation.coordinate,
      color: color,
      type: notation.type,
      file: notation.file,
      isCastling: notation.isCastling,
    );
  }

  @override
  String toString() {
    // return '${type?.initial ?? ''}${file?.label ?? ''}$coordinate';
    return line;
  }
}
