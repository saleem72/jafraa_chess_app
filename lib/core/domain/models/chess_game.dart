// ignore_for_file: public_member_api_docs, sort_constructors_first
//

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
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
  blackElo,
  timeControl,
  endTime,
  termination;

  String get label {
    return toString().split('.').last.capitalize();
  }

  static ChessGamePropertyType? fromString(String text) {
    return ChessGamePropertyType.values.firstWhereOrNull(
        (element) => element.label.toLowerCase() == text.toLowerCase());
  }
}

class ChessGame extends Equatable {
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
  final String? timeControl;
  final String? endTime;
  final String? termination;

  @override
  List<Object?> get props => [notations];

  const ChessGame({
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
    this.timeControl,
    this.endTime,
    this.termination,
  });

  static ChessGame fromString(String value) {
    // final text = value.replaceAll('\n', ' ');
    String text = value.trim().replaceAll('\r', ' ').replaceAll('\n', ' ');
    const regStr = '[\\[].*[\\]]';

    const moveRegStr = '[1\\.].*\n*.*';
    final regex = RegExp(regStr);

    final outcome = regex.allMatches(value);

    final details = outcome.map((e) => e.group(0)).whereType<String>().toList();
    final properties = details
        .map((e) => ChessGameProperty.fromString(e))
        .whereType<ChessGameProperty>()
        .toList();

    final moveRegex = RegExp(moveRegStr);
    for (final item in details) {
      text = text.replaceAll(item, '');
    }
    text = text.trim();
    final movesOutcome = moveRegex.allMatches(text);

    final moveDetails =
        movesOutcome.map((e) => e.group(0)).whereType<String>().toList();

    List<ChessNotation> list = [];
    if (moveDetails.isNotEmpty) {
      list = NotationsList.fromString(moveDetails.first);
    }

    return ChessGame(
      notations: list,
      event: properties.valueFor(ChessGamePropertyType.event),
      site: properties.valueFor(ChessGamePropertyType.site),
      date: properties.valueFor(ChessGamePropertyType.date),
      round: properties.valueFor(ChessGamePropertyType.round),
      white: properties.valueFor(ChessGamePropertyType.white),
      black: properties.valueFor(ChessGamePropertyType.black),
      result: properties.valueFor(ChessGamePropertyType.result),
      eco: properties.valueFor(ChessGamePropertyType.eco),
      whiteElo: properties.valueFor(ChessGamePropertyType.whiteElo),
      blackElo: properties.valueFor(ChessGamePropertyType.blackElo),
      timeControl: properties.valueFor(ChessGamePropertyType.timeControl),
      endTime: properties.valueFor(ChessGamePropertyType.endTime),
      termination: properties.valueFor(ChessGamePropertyType.termination),
    );
  }
}

class ChessGameProperty {
  final ChessGamePropertyType? type;
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
    final frag = text.split('"');
    if (frag.length != 3) {
      return null;
    }
    final property = frag[0].trim();
    final temp = frag[1].trim().removeQuotation();
    final type = ChessGamePropertyType.fromString(property);
    return ChessGameProperty(type: type, property: property, value: temp);
  }

  @override
  String toString() =>
      'property: $property, ${type?.label ?? ''} value: $value';
}

extension ChessGamePropertyList on List<ChessGameProperty> {
  String? valueFor(ChessGamePropertyType type) {
    return firstWhereOrNull((element) => element.type == type)?.value;
  }
}
