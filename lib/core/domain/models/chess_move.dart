//

import 'package:jafraa_chess_app/core/domain/extensions/string_extension.dart';

import 'chess_coordinate.dart';
import 'file_notation.dart';
import 'chess_piece_properties.dart';

class ChessMove {
  final String line;
  final ChessPieceType? type;
  final FileNotation? file;
  final ChessCoordinate coordinate;

  ChessMove._({
    required this.line,
    this.type,
    this.file,
    required this.coordinate,
  });

  factory ChessMove.empty() => ChessMove._(
        line: '',
        coordinate: const ChessCoordinate(file: FileNotation.a, rank: 1),
      );

  static ChessMove? fromString(String value) {
    if (value == '1-0' || value == '0-1' || value == '0-0') {
      return null;
    }
    String text = value.removePlus().replaceAll('#', '');

    if (text == 'O-O') {
      return ChessMove._(
        line: text,
        type: ChessPieceType.king,
        coordinate: const ChessCoordinate(file: FileNotation.g, rank: 1),
      );
    }

    if (text == 'O-O-O') {
      return ChessMove._(
        line: text,
        type: ChessPieceType.king,
        coordinate: const ChessCoordinate(file: FileNotation.c, rank: 1),
      );
    }
    if (text.length == 2) {
      return ChessMove._(
        line: value,
        coordinate: ChessCoordinate.fromString(text),
      );
    }

    if (text.length == 3) {
      final moveTypeStr = text[0];
      final moveType = ChessPieceType.fromString(moveTypeStr);
      final coordinate = ChessCoordinate.fromString(text.substring(1));
      return ChessMove._(line: value, type: moveType, coordinate: coordinate);
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
        return ChessMove._(
            line: value, type: moveType, file: file, coordinate: coordinate);
      } else {
        final moveTypeStr = text[0];
        final moveType = ChessPieceType.fromString(moveTypeStr);
        FileNotation? file;

        if (FileNotation.potentialFiles.contains(text[1])) {
          file = FileNotation.fromLetter(text[1]);
        } else if (text[1] == 'x' || text[1] == 'X') {
          file = null;
        } else {
          file = null;
        }

        final coordinate = ChessCoordinate.fromString(text.substring(2));
        return ChessMove._(
            line: value, type: moveType, file: file, coordinate: coordinate);
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

      return ChessMove._(
          line: value, type: type, file: file, coordinate: coordinate);
    }

    return null;
  }

  @override
  String toString() =>
      '$line: ${(type?.initial ?? '')}${file?.label ?? ''}$coordinate';
}
