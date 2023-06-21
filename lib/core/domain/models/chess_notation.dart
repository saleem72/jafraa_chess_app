//

import 'package:equatable/equatable.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_piece_properties.dart';

import 'notation_move.dart';

class ChessNotation extends Equatable {
  final String line;
  final int number;
  final NotationMove whiteMove;
  final NotationMove blackMove;

  @override
  List<Object?> get props => [line, number, whiteMove, blackMove];

  const ChessNotation._({
    required this.line,
    required this.number,
    required this.whiteMove,
    required this.blackMove,
  });

  static ChessNotation? fromItem(String text) {
    // print(text);
    String value = text;

    List<String> steps = [];
    if (value.contains('. ')) {
      steps = value.split(' ');
    } else if (value.contains('.')) {
      final temp = value.replaceFirst('.', '. ');
      steps = temp.split(' ');
    }

    if (steps.length < 2) {
      return null;
    }
    final strNumber = steps[0].substring(0, steps[0].length - 1);
    final optionalNumber = int.tryParse(strNumber);
    if (optionalNumber == null) {
      return null;
    }

    final whiteMove = steps[1];
    String? blackMove;
    if (steps.length == 3) {
      blackMove = steps[2];
    }

    return ChessNotation._(
      line: text,
      number: optionalNumber,
      whiteMove: NotationMove.fromString(whiteMove, ChessPieceColor.white) ??
          NotationMove.empty(),
      blackMove: blackMove == null
          ? NotationMove.empty()
          : NotationMove.fromString(blackMove, ChessPieceColor.black) ??
              NotationMove.empty(),
    );
  }

  @override
  String toString() => '$line\nwhite: $whiteMove\nblack: $blackMove';
}

extension NotationsList on List<ChessNotation> {
  static List<ChessNotation> fromString(String text) {
    // (?<!\V(\d\/\d))(?<!\V(\d\/))
    //[^1/2][^1/]
    // const regString =
    //     '[1-9][0-9]*\\.\\s*\\S*\\s*\\S*(?<!\\V(\\d-\\d))(?<!\\V(\\d-))(?<!\\V(\\s\\d))(?<!(1\\/2-?))(?<!(1\\/))(?<!(-1))(?<!(\\s*1\\s*))';
    const regString = '[1-9][0-9]*\\.\\s*\\S*\\s*\\S*';

    final regex = RegExp(regString);
    final value = text.trim().replaceAll('\n', ' ');

    final regSteps = regex.allMatches(value);

    final strSteps =
        regSteps.map((e) => e.group(0)).toList().whereType<String>().toList();

    final steps = strSteps
        .map((e) => ChessNotation.fromItem(e))
        .whereType<ChessNotation>()
        .toList();

    return steps;
  }
}
