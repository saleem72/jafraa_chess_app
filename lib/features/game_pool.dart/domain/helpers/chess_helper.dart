//

import 'package:collection/collection.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_notations.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_piece.dart';

import '../../../../core/domain/models/chess_coordinate.dart';
import '../../../../core/domain/models/chess_piece_properties.dart';

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
    final white = coloredGroup(ChessPieceColor.white);
    final black = coloredGroup(ChessPieceColor.black);
    var newList = List<ChessPiece>.from(white)..addAll(black);
    newList.add(
      ChessPiece.king(
        color: ChessPieceColor.black,
        coordinate: const ChessCoordinate(file: FileNotation.e, rank: 3),
      ),
    );
    return newList;
  }

  static List<ChessPiece> coloredGroup(ChessPieceColor color) {
    final mainRank = color == ChessPieceColor.black ? 8 : 1;
    final pawnsRank = color == ChessPieceColor.black ? 7 : 2;
    final List<ChessPiece> result = [];
    result.add(
      ChessPiece.rock(
        color: color,
        coordinate: ChessCoordinate(file: FileNotation.a, rank: mainRank),
      ),
    );
    result.add(
      ChessPiece.knight(
        color: color,
        coordinate: ChessCoordinate(file: FileNotation.b, rank: mainRank),
      ),
    );
    result.add(
      ChessPiece.pishop(
        color: color,
        coordinate: ChessCoordinate(file: FileNotation.c, rank: mainRank),
      ),
    );
    result.add(
      ChessPiece.queen(
        color: color,
        coordinate: ChessCoordinate(file: FileNotation.d, rank: mainRank),
      ),
    );
    result.add(
      ChessPiece.king(
        color: color,
        coordinate: ChessCoordinate(file: FileNotation.e, rank: mainRank),
      ),
    );
    result.add(
      ChessPiece.pishop(
        color: color,
        coordinate: ChessCoordinate(file: FileNotation.f, rank: mainRank),
      ),
    );
    result.add(
      ChessPiece.knight(
        color: color,
        coordinate: ChessCoordinate(file: FileNotation.g, rank: mainRank),
      ),
    );
    result.add(
      ChessPiece.rock(
        color: color,
        coordinate: ChessCoordinate(file: FileNotation.h, rank: mainRank),
      ),
    );

    final pawns = FileNotation.values.map(
      (e) => ChessPiece.pawn(
        color: color,
        coordinate: ChessCoordinate(file: e, rank: pawnsRank),
      ),
    );
    result.addAll(pawns);
    return result;
  }
}

extension ChessPieceList on List<ChessPiece> {
  ChessPiece? atIndex(int index) {
    final coordinate = ChessHelper.getCoordinate(index);

    return firstWhereOrNull((element) => element.coordinate == coordinate);
  }

  ChessPiece? atCoordinates(ChessCoordinate coordinate) {
    return firstWhereOrNull((element) => element.coordinate == coordinate);
  }

  List<ChessCoordinate> possibleMoves(ChessPiece piece) {
    final coordinate = piece.coordinate;
    final type = piece.type;
    return possibleMove(type: type, color: piece.color, coordinate: coordinate);
  }

  List<ChessCoordinate> possibleMove({
    required ChessPieceType type,
    required ChessPieceColor color,
    required ChessCoordinate coordinate,
  }) {
    switch (type) {
      case ChessPieceType.pawn:
        if (color == ChessPieceColor.white) {
          return whitePawnMoves(coordinate);
        } else {
          return blackPawnMoves(coordinate);
        }
      case ChessPieceType.rock:
        return rockMoves(coordinate, color);
      case ChessPieceType.knight:
        return knightMoves(coordinate, color);
      case ChessPieceType.pishop:
        return pishopMoves(coordinate, color);
      case ChessPieceType.queen:
        return queenMoves(coordinate, color);
      case ChessPieceType.king:
        return kingMoves(coordinate, color);
    }
  }

  List<ChessCoordinate> whitePawnMoves(ChessCoordinate coordinate) {
    final List<ChessCoordinate> result = [];
    // one square
    final oneSquareFile = coordinate.file.value;
    final oneSquareRank = coordinate.rank + 1;
    if (isOnBoard(file: oneSquareFile, rank: oneSquareRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(oneSquareFile),
        rank: oneSquareRank,
      );
      result.add(coordinate);
    }

    // tow squares
    if (coordinate.rank == 2) {
      final towSquaresFile = coordinate.file.value;
      final towSquaresRank = coordinate.rank + 2;
      if (isOnBoard(file: towSquaresFile, rank: towSquaresRank)) {
        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(towSquaresFile),
          rank: towSquaresRank,
        );
        result.add(coordinate);
      }
    }
    return result;
  }

  List<ChessCoordinate> blackPawnMoves(ChessCoordinate coordinate) {
    final List<ChessCoordinate> result = [];
    // one square
    final oneSquareFile = coordinate.file.value;
    final oneSquareRank = coordinate.rank - 1;
    if (isOnBoard(file: oneSquareFile, rank: oneSquareRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(oneSquareFile),
        rank: oneSquareRank,
      );
      result.add(coordinate);
    }

    // tow squares
    if (coordinate.rank == 7) {
      final towSquaresFile = coordinate.file.value;
      final towSquaresRank = coordinate.rank - 2;
      if (isOnBoard(file: towSquaresFile, rank: towSquaresRank)) {
        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(towSquaresFile),
          rank: towSquaresRank,
        );
        result.add(coordinate);
      }
    }
    return result;
  }

  List<ChessCoordinate> rockMoves(
      ChessCoordinate coordinate, ChessPieceColor color) {
    final List<ChessCoordinate> result = [];
    final file = coordinate.file.value;
    final rank = coordinate.rank;
    int newFile = -1;
    int newRank = -1;
    // Vertical

    newFile = file;
    newRank = rank - 1;
    while (true) {
      if (isOnBoard(file: newFile, rank: newRank)) {
        final piece = atCoordinates(ChessCoordinate(
            file: FileNotation.fromValue(newFile), rank: newRank));
        if (piece != null) {
          if (piece.color == color) {
            break;
          } else {
            final coordinate = ChessCoordinate(
              file: FileNotation.fromValue(newFile),
              rank: newRank,
            );
            result.add(coordinate);
            break;
          }
        }

        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );
        result.add(coordinate);
        newRank--;
      } else {
        break;
      }
    }

    newFile = file;
    newRank = rank + 1;
    while (true) {
      if (isOnBoard(file: newFile, rank: newRank)) {
        final piece = atCoordinates(ChessCoordinate(
            file: FileNotation.fromValue(newFile), rank: newRank));
        if (piece != null) {
          if (piece.color == color) {
            break;
          } else {
            final coordinate = ChessCoordinate(
              file: FileNotation.fromValue(newFile),
              rank: newRank,
            );
            result.add(coordinate);
            break;
          }
        }

        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );
        result.add(coordinate);
        newRank++;
      } else {
        break;
      }
    }

    // Horizontal
    newFile = file - 1;
    newRank = rank;
    while (true) {
      if (isOnBoard(file: newFile, rank: newRank)) {
        final piece = atCoordinates(ChessCoordinate(
            file: FileNotation.fromValue(newFile), rank: newRank));
        if (piece != null) {
          if (piece.color == color) {
            break;
          } else {
            final coordinate = ChessCoordinate(
              file: FileNotation.fromValue(newFile),
              rank: newRank,
            );
            result.add(coordinate);
            break;
          }
        }

        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );
        result.add(coordinate);
        newFile--;
      } else {
        break;
      }
    }

    newFile = file + 1;
    newRank = rank;
    while (true) {
      if (isOnBoard(file: newFile, rank: newRank)) {
        final piece = atCoordinates(ChessCoordinate(
            file: FileNotation.fromValue(newFile), rank: newRank));
        if (piece != null) {
          if (piece.color == color) {
            break;
          } else {
            final coordinate = ChessCoordinate(
              file: FileNotation.fromValue(newFile),
              rank: newRank,
            );
            result.add(coordinate);
            break;
          }
        }

        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );
        result.add(coordinate);
        newFile++;
      } else {
        break;
      }
    }

    return result;
  }

  List<ChessCoordinate> knightMoves(
      ChessCoordinate coordinate, ChessPieceColor color) {
    final List<ChessCoordinate> result = [];
    final file = coordinate.file.value;
    final rank = coordinate.rank;

    // left north
    final leftNorthFile = file - 1;
    final leftNorthRank = rank + 2;
    if (isOnBoard(file: leftNorthFile, rank: leftNorthRank)) {
      final piece = atCoordinates(ChessCoordinate(
          file: FileNotation.fromValue(leftNorthFile), rank: leftNorthRank));
      if (piece?.color != color) {
        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(leftNorthFile),
          rank: leftNorthRank,
        );
        result.add(coordinate);
      }
    }

    // left north west
    final leftNorthWestFile = file - 2;
    final leftNorthWestRank = rank + 1;
    if (isOnBoard(file: leftNorthWestFile, rank: leftNorthWestRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(leftNorthWestFile),
        rank: leftNorthWestRank,
      );
      final piece = atCoordinates(coordinate);

      if (piece?.color != color) {
        result.add(coordinate);
      }
    }

    // left south west
    final leftSouthWestFile = file - 2;
    final leftSouthWestRank = rank - 1;
    if (isOnBoard(file: leftSouthWestFile, rank: leftSouthWestRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(leftSouthWestFile),
        rank: leftSouthWestRank,
      );
      final piece = atCoordinates(coordinate);

      if (piece?.color != color) {
        result.add(coordinate);
      }
    }

    // left south
    final leftSouthFile = file - 1;
    final leftSouthRank = rank - 2;
    if (isOnBoard(file: leftSouthFile, rank: leftSouthRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(leftSouthFile),
        rank: leftSouthRank,
      );
      final piece = atCoordinates(coordinate);

      if (piece?.color != color) {
        result.add(coordinate);
      }
    }

    // right north
    final rightNorthFile = file + 1;
    final rightNorthRank = rank + 2;
    if (isOnBoard(file: rightNorthFile, rank: rightNorthRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(rightNorthFile),
        rank: rightNorthRank,
      );
      final piece = atCoordinates(coordinate);

      if (piece?.color != color) {
        result.add(coordinate);
      }
    }

    // right north east
    final rightNorthEastFile = file + 2;
    final rightNorthEastRank = rank + 1;
    if (isOnBoard(file: rightNorthEastFile, rank: rightNorthEastRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(rightNorthEastFile),
        rank: rightNorthEastRank,
      );
      final piece = atCoordinates(coordinate);

      if (piece?.color != color) {
        result.add(coordinate);
      }
    }

    // right south east
    final rightSouthEastFile = file + 2;
    final rightSouthEastRank = rank - 1;
    if (isOnBoard(file: rightSouthEastFile, rank: rightSouthEastRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(rightSouthEastFile),
        rank: rightSouthEastRank,
      );
      final piece = atCoordinates(coordinate);

      if (piece?.color != color) {
        result.add(coordinate);
      }
    }

    // right south
    final rightSouthFile = file + 1;
    final rightSouthRank = rank - 2;
    if (isOnBoard(file: rightSouthFile, rank: rightSouthRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(rightSouthFile),
        rank: rightSouthRank,
      );
      final piece = atCoordinates(coordinate);

      if (piece?.color != color) {
        result.add(coordinate);
      }
    }

    return result;
  }

  List<ChessCoordinate> pishopMoves(
      ChessCoordinate coordinate, ChessPieceColor color) {
    final List<ChessCoordinate> result = [];
    final file = coordinate.file.value;
    final rank = coordinate.rank;
    int newFile = -1;
    int newRank = -1;

    // [-1, -1]
    newFile = file - 1;
    newRank = rank - 1;
    while (true) {
      if (isOnBoard(file: newFile, rank: newRank)) {
        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );
        final piece = atCoordinates(coordinate);
        if (piece != null) {
          if (piece.color == color) {
            break;
          } else {
            result.add(coordinate);
            break;
          }
        }
        result.add(coordinate);
        newFile--;
        newRank--;
      } else {
        break;
      }
    }

    // [+1, +1]
    newFile = file + 1;
    newRank = rank + 1;
    while (true) {
      if (isOnBoard(file: newFile, rank: newRank)) {
        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );
        final piece = atCoordinates(coordinate);
        if (piece != null) {
          if (piece.color == color) {
            break;
          } else {
            result.add(coordinate);
            break;
          }
        }
        result.add(coordinate);
        newFile++;
        newRank++;
      } else {
        break;
      }
    }

    // [-1, +1]
    newFile = file - 1;
    newRank = rank + 1;
    while (true) {
      if (isOnBoard(file: newFile, rank: newRank)) {
        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );

        final piece = atCoordinates(coordinate);
        if (piece != null) {
          if (piece.color == color) {
            break;
          } else {
            result.add(coordinate);
            break;
          }
        }
        result.add(coordinate);
        newFile--;
        newRank++;
      } else {
        break;
      }
    }

    // [+1, -1]
    newFile = file + 1;
    newRank = rank - 1;
    while (true) {
      if (isOnBoard(file: newFile, rank: newRank)) {
        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );
        final piece = atCoordinates(coordinate);
        if (piece != null) {
          if (piece.color == color) {
            break;
          } else {
            result.add(coordinate);
            break;
          }
        }
        result.add(coordinate);
        newFile++;
        newRank--;
      } else {
        break;
      }
    }

    return result;
  }

  List<ChessCoordinate> kingMoves(
      ChessCoordinate coordinate, ChessPieceColor color) {
    final List<ChessCoordinate> result = [];
    final file = coordinate.file.value;
    final rank = coordinate.rank;
    int newFile = -1;
    int newRank = -1;

    // [-1, -1]
    newFile = file - 1;
    newRank = rank - 1;
    if (isOnBoard(file: newFile, rank: newRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(newFile),
        rank: newRank,
      );
      final piece = atCoordinates(coordinate);
      if (piece != null) {
        if (piece.color != color) {
          result.add(coordinate);
        }
      } else {
        result.add(coordinate);
      }
    }

    // [+1, +1]
    newFile = file + 1;
    newRank = rank + 1;
    if (isOnBoard(file: newFile, rank: newRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(newFile),
        rank: newRank,
      );
      final piece = atCoordinates(coordinate);
      if (piece != null) {
        if (piece.color != color) {
          result.add(coordinate);
        }
      } else {
        result.add(coordinate);
      }
    }

    // [-1, +1]
    newFile = file - 1;
    newRank = rank + 1;
    if (isOnBoard(file: newFile, rank: newRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(newFile),
        rank: newRank,
      );
      final piece = atCoordinates(coordinate);
      if (piece != null) {
        if (piece.color != color) {
          result.add(coordinate);
        }
      } else {
        result.add(coordinate);
      }
    }
    // [+1, -1]
    newFile = file + 1;
    newRank = rank - 1;
    if (isOnBoard(file: newFile, rank: newRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(newFile),
        rank: newRank,
      );
      final piece = atCoordinates(coordinate);
      if (piece != null) {
        if (piece.color != color) {
          result.add(coordinate);
        }
      } else {
        result.add(coordinate);
      }
    }

    newFile = file;
    newRank = rank - 1;
    if (isOnBoard(file: newFile, rank: newRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(newFile),
        rank: newRank,
      );
      final piece = atCoordinates(coordinate);
      if (piece != null) {
        if (piece.color != color) {
          result.add(coordinate);
        }
      } else {
        result.add(coordinate);
      }
    }

    newFile = file;
    newRank = rank + 1;
    if (isOnBoard(file: newFile, rank: newRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(newFile),
        rank: newRank,
      );
      final piece = atCoordinates(coordinate);
      if (piece != null) {
        if (piece.color != color) {
          result.add(coordinate);
        }
      } else {
        result.add(coordinate);
      }
    }

    newFile = file - 1;
    newRank = rank;
    if (isOnBoard(file: newFile, rank: newRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(newFile),
        rank: newRank,
      );
      final piece = atCoordinates(coordinate);
      if (piece != null) {
        if (piece.color != color) {
          result.add(coordinate);
        }
      } else {
        result.add(coordinate);
      }
    }

    newFile = file + 1;
    newRank = rank;
    if (isOnBoard(file: newFile, rank: newRank)) {
      final coordinate = ChessCoordinate(
        file: FileNotation.fromValue(newFile),
        rank: newRank,
      );
      final piece = atCoordinates(coordinate);
      if (piece != null) {
        if (piece.color != color) {
          result.add(coordinate);
        }
      } else {
        result.add(coordinate);
      }
    }

    return result;
  }

  List<ChessCoordinate> queenMoves(
      ChessCoordinate coordinate, ChessPieceColor color) {
    final List<ChessCoordinate> result = [];
    final file = coordinate.file.value;
    final rank = coordinate.rank;
    int newFile = -1;
    int newRank = -1;

    // [-1, -1]
    newFile = file - 1;
    newRank = rank - 1;
    while (true) {
      if (isOnBoard(file: newFile, rank: newRank)) {
        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );
        final piece = atCoordinates(coordinate);
        if (piece != null) {
          if (piece.color == color) {
            break;
          } else {
            result.add(coordinate);
            break;
          }
        }

        result.add(coordinate);
        newFile--;
        newRank--;
      } else {
        break;
      }
    }

    // [+1, +1]
    newFile = file + 1;
    newRank = rank + 1;
    while (true) {
      if (isOnBoard(file: newFile, rank: newRank)) {
        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );
        final piece = atCoordinates(coordinate);
        if (piece != null) {
          if (piece.color == color) {
            break;
          } else {
            result.add(coordinate);
            break;
          }
        }
        result.add(coordinate);
        newFile++;
        newRank++;
      } else {
        break;
      }
    }

    // [-1, +1]
    newFile = file - 1;
    newRank = rank + 1;
    while (true) {
      if (isOnBoard(file: newFile, rank: newRank)) {
        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );

        final piece = atCoordinates(coordinate);
        if (piece != null) {
          if (piece.color == color) {
            break;
          } else {
            result.add(coordinate);
            break;
          }
        }
        result.add(coordinate);
        newFile--;
        newRank++;
      } else {
        break;
      }
    }
    // [+1, -1]
    newFile = file + 1;
    newRank = rank - 1;
    while (true) {
      if (isOnBoard(file: newFile, rank: newRank)) {
        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );

        final piece = atCoordinates(coordinate);
        if (piece != null) {
          if (piece.color == color) {
            break;
          } else {
            result.add(coordinate);
            break;
          }
        }
        result.add(coordinate);
        newFile++;
        newRank--;
      } else {
        break;
      }
    }

    newFile = file;
    newRank = rank - 1;
    while (true) {
      if (isOnBoard(file: newFile, rank: newRank)) {
        final piece = atCoordinates(ChessCoordinate(
            file: FileNotation.fromValue(newFile), rank: newRank));
        if (piece != null) {
          if (piece.color == color) {
            break;
          } else {
            final coordinate = ChessCoordinate(
              file: FileNotation.fromValue(newFile),
              rank: newRank,
            );
            result.add(coordinate);
            break;
          }
        }

        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );
        result.add(coordinate);
        newRank--;
      } else {
        break;
      }
    }

    newFile = file;
    newRank = rank + 1;
    while (true) {
      if (isOnBoard(file: newFile, rank: newRank)) {
        final piece = atCoordinates(ChessCoordinate(
            file: FileNotation.fromValue(newFile), rank: newRank));
        if (piece != null) {
          if (piece.color == color) {
            break;
          } else {
            final coordinate = ChessCoordinate(
              file: FileNotation.fromValue(newFile),
              rank: newRank,
            );
            result.add(coordinate);
            break;
          }
        }

        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );
        result.add(coordinate);
        newRank++;
      } else {
        break;
      }
    }

    // Horizontal
    newFile = file - 1;
    newRank = rank;
    while (true) {
      if (isOnBoard(file: newFile, rank: newRank)) {
        final piece = atCoordinates(ChessCoordinate(
            file: FileNotation.fromValue(newFile), rank: newRank));
        if (piece != null) {
          if (piece.color == color) {
            break;
          } else {
            final coordinate = ChessCoordinate(
              file: FileNotation.fromValue(newFile),
              rank: newRank,
            );
            result.add(coordinate);
            break;
          }
        }

        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );
        result.add(coordinate);
        newFile--;
      } else {
        break;
      }
    }

    newFile = file + 1;
    newRank = rank;
    while (true) {
      if (isOnBoard(file: newFile, rank: newRank)) {
        final piece = atCoordinates(ChessCoordinate(
            file: FileNotation.fromValue(newFile), rank: newRank));
        if (piece != null) {
          if (piece.color == color) {
            break;
          } else {
            final coordinate = ChessCoordinate(
              file: FileNotation.fromValue(newFile),
              rank: newRank,
            );
            result.add(coordinate);
            break;
          }
        }

        final coordinate = ChessCoordinate(
          file: FileNotation.fromValue(newFile),
          rank: newRank,
        );
        result.add(coordinate);
        newFile++;
      } else {
        break;
      }
    }

    return result;
  }

  static bool isOnBoard({required int file, required int rank}) {
    return file >= 0 && file < 8 && rank >= 1 && rank < 9;
  }
}
