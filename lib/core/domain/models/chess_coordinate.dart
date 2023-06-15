// ignore_for_file: public_member_api_docs, sort_constructors_first
//

import 'package:equatable/equatable.dart';

import 'package:jafraa_chess_app/features/game_pool.dart/domain/helpers/chess_helper.dart';

import 'file_notation.dart';

class ChessCoordinate extends Equatable {
  final FileNotation file;
  final int rank;
  const ChessCoordinate({
    required this.file,
    required this.rank,
  });

  factory ChessCoordinate.fromString(String text) {
    final coordinateFileStr = text[0];
    FileNotation coordinateFile;
    if (FileNotation.potentialFiles.contains(coordinateFileStr)) {
      coordinateFile = FileNotation.fromLetter(coordinateFileStr);
    } else {
      coordinateFile = FileNotation.a;
    }

    final rank = int.parse(text[1]);
    return ChessCoordinate(
      file: coordinateFile,
      rank: rank,
    );
  }

  @override
  List<Object?> get props => [file, rank];

  String get caption {
    if (rank == 1 && file == FileNotation.a) {
      return '$file, $rank';
    }
    if (rank == 1) {
      return file.label;
    }

    if (file == FileNotation.a) {
      return rank.toString();
    }

    return '';
  }

  @override
  String toString() => '${file.label}$rank';
}

extension ChessCoordinateList on List<ChessCoordinate> {
  bool got(int index) {
    final coordinate = ChessHelper.getCoordinate(index);
    return contains(coordinate);
  }
}
