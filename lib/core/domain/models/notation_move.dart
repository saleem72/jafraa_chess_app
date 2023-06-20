//

import 'package:equatable/equatable.dart';
import 'package:jafraa_chess_app/core/domain/extensions/string_extension.dart';

import 'chess_coordinate.dart';
import 'file_notation.dart';
import 'chess_piece_properties.dart';

class NotationMove extends Equatable {
  final String line;
  final ChessPieceType? type;
  final FileNotation? file;
  final ChessCoordinate coordinate;
  final bool isCastling;

  @override
  List<Object?> get props => [line, type, file, coordinate];

  const NotationMove._({
    required this.line,
    this.type,
    this.file,
    required this.coordinate,
    required this.isCastling,
  });

  factory NotationMove.empty() => const NotationMove._(
        line: '',
        coordinate: ChessCoordinate(
          file: FileNotation.a,
          rank: 1,
        ),
        isCastling: false,
      );

  static NotationMove? fromString(String value, ChessPieceColor color) {
    if (value == '1-0' || value == '0-1' || value == '0-0') {
      return null;
    }
    String text = value.removePlus().replaceAll('#', '');

    if (text == 'O-O') {
      return NotationMove._(
        line: 'o-o',
        type: ChessPieceType.king,
        coordinate: ChessCoordinate(
            file: FileNotation.g, rank: color == ChessPieceColor.white ? 1 : 8),
        isCastling: true,
      );
    }

    if (text == 'O-O-O') {
      return NotationMove._(
        line: 'o-o-o',
        type: ChessPieceType.king,
        coordinate: ChessCoordinate(
            file: FileNotation.c, rank: color == ChessPieceColor.white ? 1 : 8),
        isCastling: true,
      );
    }
    if (text.length == 2) {
      return NotationMove._(
        line: value,
        coordinate: ChessCoordinate.fromString(text),
        isCastling: false,
      );
    }

    if (text.length == 3) {
      final moveTypeStr = text[0];
      final moveType = ChessPieceType.fromString(moveTypeStr);
      final coordinate = ChessCoordinate.fromString(text.substring(1));
      return NotationMove._(
        line: value,
        type: moveType,
        coordinate: coordinate,
        isCastling: false,
      );
    }

    if (text.length == 4) {
      if (text.containX()) {
        final moveTypeStr = text[0];
        final moveType = ChessPieceType.fromString(moveTypeStr);
        FileNotation? file;
        if (FileNotation.potentialFiles.contains(text[0])) {
          file = FileNotation.fromLetter(text[0]);
        } else {
          file = null;
        }
        final coordinate = ChessCoordinate.fromString(text.substring(2));
        return NotationMove._(
          line: value,
          type: moveType,
          file: file,
          coordinate: coordinate,
          isCastling: false,
        );
      } else {
        final moveTypeStr = text[0];
        final moveType = ChessPieceType.fromString(moveTypeStr);
        FileNotation? file;

        if (FileNotation.potentialFiles.contains(text[1])) {
          file = FileNotation.fromLetter(text[1]);
        } else {
          file = null;
        }

        final coordinate = ChessCoordinate.fromString(text.substring(2));
        return NotationMove._(
            line: value,
            type: moveType,
            file: file,
            coordinate: coordinate,
            isCastling: false);
      }
    }

    if (text.length == 5) {
      final moveTypeStr = text[0];
      final type = ChessPieceType.fromString(moveTypeStr);

      final moveFileStr = text[1];
      FileNotation? file;

      if (FileNotation.potentialFiles.contains(moveFileStr)) {
        file = FileNotation.fromLetter(moveFileStr);
      } else {
        file = null;
      }

      final coordinate = ChessCoordinate.fromString(text.substring(3));

      return NotationMove._(
          line: value,
          type: type,
          file: file,
          coordinate: coordinate,
          isCastling: false);
    }

    return null;
  }

  @override
  String toString() =>
      '${(type?.initial ?? '')}${file?.label ?? ''}$coordinate';
}
