//

import 'chess_move.dart';

class ChessNotation {
  final String line;
  final int number;
  final ChessMove whiteMove;
  final ChessMove blackMove;

  ChessNotation._({
    required this.line,
    required this.number,
    required this.whiteMove,
    required this.blackMove,
  });

  static ChessNotation? fromItem(String text) {
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
      whiteMove: ChessMove.fromString(whiteMove) ?? ChessMove.empty(),
      blackMove: blackMove == null
          ? ChessMove.empty()
          : ChessMove.fromString(blackMove) ?? ChessMove.empty(),
    );
  }

  @override
  String toString() => '$line\nwhite: $whiteMove\nblack: $blackMove';
}

extension NotationsList on List<ChessNotation> {
  static List<ChessNotation> fromString(String text) {
    // const regString =
    //     '\\d-\\d|[1-9][0-9]*.\\s\\S*\\s\\S*|[1-9][0-9]*.\\s\\S*|[1-9][0-9]*.\\S*\\s\\S*|[1-9][0-9]*.\\S*';
    const regString =
        '[1-9][0-9]*\\.\\s*\\S*\\s*\\S*(?<!\\V(\\d-\\d))(?<!\\V(\\d-))(?<!\\V(\\s\\d))';
    final regex = RegExp(regString);
    final value = text.trim().replaceAll('\n', ' ');

    final regSteps = regex.allMatches(value);

    final strSteps =
        regSteps.map((e) => e.group(0)).toList().whereType<String>().toList();

    for (final step in strSteps) {
      print(step);
    }

    final steps = strSteps
        .map((e) => ChessNotation.fromItem(e))
        .whereType<ChessNotation>()
        .toList();

    return steps;
  }
}
