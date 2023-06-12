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

  const ChessPiece._({
    required this.type,
    required this.color,
    required this.coordinate,
  });

  @override
  List<Object?> get props => [type, color, coordinate];

  ChessPiece moveTo(ChessCoordinate newCoordinate) {
    final result =
        ChessPiece._(type: type, color: color, coordinate: newCoordinate);
    return result;
  }

  factory ChessPiece.pawn(
          {required ChessPieceColor color,
          required ChessCoordinate coordinate}) =>
      ChessPiece._(
        type: ChessPieceType.pawn,
        color: color,
        coordinate: coordinate,
      );

  factory ChessPiece.rock(
          {required ChessPieceColor color,
          required ChessCoordinate coordinate}) =>
      ChessPiece._(
        type: ChessPieceType.rock,
        color: color,
        coordinate: coordinate,
      );

  factory ChessPiece.knight(
          {required ChessPieceColor color,
          required ChessCoordinate coordinate}) =>
      ChessPiece._(
        type: ChessPieceType.knight,
        color: color,
        coordinate: coordinate,
      );

  factory ChessPiece.bishop(
          {required ChessPieceColor color,
          required ChessCoordinate coordinate}) =>
      ChessPiece._(
        type: ChessPieceType.bishop,
        color: color,
        coordinate: coordinate,
      );

  factory ChessPiece.queen(
          {required ChessPieceColor color,
          required ChessCoordinate coordinate}) =>
      ChessPiece._(
        type: ChessPieceType.queen,
        color: color,
        coordinate: coordinate,
      );

  factory ChessPiece.king(
          {required ChessPieceColor color,
          required ChessCoordinate coordinate}) =>
      ChessPiece._(
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
          return ChessIcons.newPawn;
        } else {
          return ChessIcons.newPawn;
        }

      case ChessPieceType.rock:
        if (color == ChessPieceColor.white) {
          return ChessIcons.newRock;
        } else {
          return ChessIcons.newRock;
        }
      case ChessPieceType.knight:
        if (color == ChessPieceColor.white) {
          return ChessIcons.newKnight;
        } else {
          return ChessIcons.newKnight;
        }
      case ChessPieceType.bishop:
        if (color == ChessPieceColor.white) {
          return ChessIcons.newBishop;
        } else {
          return ChessIcons.newBishop;
        }
      case ChessPieceType.queen:
        if (color == ChessPieceColor.white) {
          return ChessIcons.newQueen;
        } else {
          return ChessIcons.newQueen;
        }
      case ChessPieceType.king:
        if (color == ChessPieceColor.white) {
          return ChessIcons.newKing;
        } else {
          return ChessIcons.newKing;
        }
    }
  }
}
