//

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jafraa_chess_app/configuration/assets/chess_components.dart';

import 'chess_coordinate.dart';
import 'chess_piece_properties.dart';

class ChessPiece extends Equatable {
  final ChessPieceType type;
  final ChessPieceColor color;
  final ChessCoordinate coordinate;

  const ChessPiece({
    required this.type,
    required this.color,
    required this.coordinate,
  });

  @override
  List<Object?> get props => [type, color, coordinate];

  ChessPiece moveTo(ChessCoordinate newCoordinate) {
    final result =
        ChessPiece(type: type, color: color, coordinate: newCoordinate);
    return result;
  }

  factory ChessPiece.pawn(
          {required ChessPieceColor color,
          required ChessCoordinate coordinate}) =>
      ChessPiece(
        type: ChessPieceType.pawn,
        color: color,
        coordinate: coordinate,
      );

  factory ChessPiece.rock(
          {required ChessPieceColor color,
          required ChessCoordinate coordinate}) =>
      ChessPiece(
        type: ChessPieceType.rock,
        color: color,
        coordinate: coordinate,
      );

  factory ChessPiece.knight(
          {required ChessPieceColor color,
          required ChessCoordinate coordinate}) =>
      ChessPiece(
        type: ChessPieceType.knight,
        color: color,
        coordinate: coordinate,
      );

  factory ChessPiece.bishop(
          {required ChessPieceColor color,
          required ChessCoordinate coordinate}) =>
      ChessPiece(
        type: ChessPieceType.bishop,
        color: color,
        coordinate: coordinate,
      );

  factory ChessPiece.queen(
          {required ChessPieceColor color,
          required ChessCoordinate coordinate}) =>
      ChessPiece(
        type: ChessPieceType.queen,
        color: color,
        coordinate: coordinate,
      );

  factory ChessPiece.king(
          {required ChessPieceColor color,
          required ChessCoordinate coordinate}) =>
      ChessPiece(
        type: ChessPieceType.king,
        color: color,
        coordinate: coordinate,
      );

  Color get realColor =>
      color == ChessPieceColor.black ? Colors.black : Colors.white;

  String get icon {
    switch (type) {
      case ChessPieceType.pawn:
        if (color == ChessPieceColor.white) {
          return ChessIcons.pawnWhite;
        } else {
          return ChessIcons.pawnBlack;
        }

      case ChessPieceType.rock:
        if (color == ChessPieceColor.white) {
          return ChessIcons.rockWhite;
        } else {
          return ChessIcons.rockBlack;
        }
      case ChessPieceType.knight:
        if (color == ChessPieceColor.white) {
          return ChessIcons.knightWhite;
        } else {
          return ChessIcons.knightBlack;
        }
      case ChessPieceType.bishop:
        if (color == ChessPieceColor.white) {
          return ChessIcons.pishopWhite;
        } else {
          return ChessIcons.pishopBlack;
        }
      case ChessPieceType.queen:
        if (color == ChessPieceColor.white) {
          return ChessIcons.queenWhite;
        } else {
          return ChessIcons.queenBlack;
        }
      case ChessPieceType.king:
        if (color == ChessPieceColor.white) {
          return ChessIcons.kingWhite;
        } else {
          return ChessIcons.kingBlack;
        }
    }
  }
}
