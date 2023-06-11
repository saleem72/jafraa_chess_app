//

import 'package:equatable/equatable.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/domain/helpers/chess_helper.dart';

import 'chess_notations.dart';

class ChessCoordinate extends Equatable {
  final FileNotation file;
  final int rank;
  const ChessCoordinate({
    required this.file,
    required this.rank,
  });

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
}

extension ChessCoordinateList on List<ChessCoordinate> {
  bool got(int index) {
    final coordinate = ChessHelper.getCoordinate(index);
    return contains(coordinate);
  }
}
