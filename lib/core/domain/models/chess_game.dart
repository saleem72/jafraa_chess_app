// ignore_for_file: public_member_api_docs, sort_constructors_first
//

import 'package:jafraa_chess_app/core/domain/extensions/string_extension.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_notation.dart';

enum ChessGamePropertyType {
  event,
  site,
  date,
  round,
  white,
  black,
  result,
  eco,
  whiteElo,
  blackElo;

  String get label {
    return toString().split('.').last.capitalize();
  }

  factory ChessGamePropertyType.fromString(String text) {
    if (text == 'ECO') {
      return ChessGamePropertyType.eco;
    }
    return ChessGamePropertyType.values
        .firstWhere((element) => element.label == text);
  }
}

class ChessGame {
  final List<ChessNotation> notations;
  final String? event;
  final String? site;
  final String? date;
  final String? round;
  final String? white;
  final String? black;
  final String? result;
  final String? eco;
  final String? whiteElo;
  final String? blackElo;

  ChessGame({
    required this.notations,
    this.event,
    this.site,
    this.date,
    this.round,
    this.white,
    this.black,
    this.result,
    this.eco,
    this.whiteElo,
    this.blackElo,
  });

  static ChessGame fromString(String value) {
    final text = value.replaceAll('\n', ' ');
    const regStr = '[\\[].*[\\]]';
    const moveRegStr = '1\\..*';
    final regex = RegExp(regStr);

    final outcome = regex.allMatches(value);

    final details = outcome.map((e) => e.group(0)).whereType<String>().toList();
    final properties = details.map((e) => ChessGameProperty.fromString(e));
    for (final property in properties) {
      print(property.toString());
    }

    final moveRegex = RegExp(moveRegStr);

    final movesOutcome = moveRegex.allMatches(text);
    print('\n*********************************\n');
    final moveDetails =
        movesOutcome.map((e) => e.group(0)).whereType<String>().toList();
    final list = NotationsList.fromString(moveDetails.first);
    return ChessGame(notations: list);
  }
}

class ChessGameProperty {
  final ChessGamePropertyType type;
  final String property;
  final String value;

  ChessGameProperty({
    required this.type,
    required this.property,
    required this.value,
  });

  static ChessGameProperty? fromString(String value) {
    final text = value.removePrackets().trim().replaceAll('\n', '');
    if (text.isEmpty) {
      return null;
    }
    // String text = value.removePrackets();
    final frag = text.split(' ');
    final property = frag[0];
    final temp = frag[1].removeQuotation();
    final type = ChessGamePropertyType.fromString(property);
    return ChessGameProperty(type: type, property: property, value: temp);
  }

  @override
  String toString() => 'property: $property, ${type.label} value: $value';
}
