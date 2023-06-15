//

import 'package:jafraa_chess_app/core/domain/models/file_notation.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_piece.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/domain/helpers/board_filler.dart';

import '../../../../core/domain/models/chess_coordinate.dart';

class ChessHelper {
  ChessHelper._();

  static String fileLabel(int index) {
    final y = index % 8;
    switch (y) {
      case 0:
        return 'A';
      case 1:
        return 'B';
      case 2:
        return 'C';
      case 3:
        return 'D';
      case 4:
        return 'E';
      case 5:
        return 'F';
      case 6:
        return 'G';
      case 7:
        return 'H';
      default:
        return '';
    }
  }

  static int getFile(int index) => index % 8;
  static int getRank(int index) => 8 - index ~/ 8;

  static ChessCoordinate getCoordinate(int index) {
    final fileValue = getFile(index);
    final file = FileNotation.fromValue(fileValue);
    final rank = getRank(index);

    final coordinate = ChessCoordinate(file: file, rank: rank);
    return coordinate;
  }

  static int getIndex({required FileNotation file, required int rank}) {
    final y = 8 - rank;
    final x = file.value;

    final index = y * 8 + x;
    return index;
  }

  static bool isLightSquare(int index) {
    final y = index ~/ 8;
    final x = index % 8;

    final isWhite = (y + x) % 2 == 0;

    return isWhite;
  }

  static List<ChessPiece> initialPieces() {
    final filler = BoardFiller();
    final newList = filler.fill();
    // newList.add(
    //   ChessPiece.king(
    //     color: ChessPieceColor.white,
    //     coordinate: const ChessCoordinate(file: FileNotation.e, rank: 4),
    //   ),
    // );
    // newList.add(
    //   ChessPiece.pawn(
    //     color: ChessPieceColor.black,
    //     coordinate: const ChessCoordinate(file: FileNotation.f, rank: 5),
    //   ),
    // );
    // newList.add(
    //   ChessPiece.pawn(
    //     color: ChessPieceColor.black,
    //     coordinate: const ChessCoordinate(file: FileNotation.g, rank: 6),
    //   ),
    // );
    return newList;
  }
}
