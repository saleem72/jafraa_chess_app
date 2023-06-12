//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jafraa_chess_app/configuration/assets/chess_components.dart';
import 'package:jafraa_chess_app/configuration/extensions/build_context_extension.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_coordinate.dart';
import 'package:jafraa_chess_app/core/domain/models/promoted_piece.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/domain/extensions/chess_piece_list_extension.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/domain/helpers/chess_helper.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/presentation/game_pool_bloc/game_pool_bloc.dart';

class ChessPiecesView extends StatelessWidget {
  const ChessPiecesView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GamePoolBloc, GamePoolState>(
      // buildWhen: (previous, current) => previous.pieces != current.pieces,
      builder: (context, state) {
        return _grid(context, state);
      },
      listenWhen: (previous, current) =>
          previous.whitePromote != current.whitePromote,
      listener: (context, state) {
        if (state.whitePromote) {
          _showDialog(context);
        }
      },
    );
  }

  Widget _grid(BuildContext context, GamePoolState state) {
    final pieces = state.pieces;
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
      ),
      itemCount: 64,
      itemBuilder: (context, index) {
        final piece = pieces.atIndex(index);
        final isItPossibleMove = state.possibleMoves.got(index);
        final coordinate = ChessHelper.getCoordinate(index);
        final isSelected = state.selectedPiece?.coordinate == coordinate;
        final color = isSelected
            ? Colors.black12
            : isItPossibleMove
                ? Colors.black26
                : null;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // if (piece != null) {
            //   context
            //       .read<GamePoolBloc>()
            //       .add(GamePoolEvent.setSelected(piece: piece));
            // } else {
            //   context.read<GamePoolBloc>().add(GamePoolEvent.clearSelected());
            // }
            context.read<GamePoolBloc>().add(GamePoolEvent.squareTapped(
                coordinate: ChessHelper.getCoordinate(index)));
          },
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  child: piece == null
                      ? const SizedBox.shrink()
                      : Image.asset(
                          piece.icon,
                          color: piece.realColor,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDialog(BuildContext context) {
    const double buttonSize = 44;
    showGeneralDialog(
        context: context,
        pageBuilder: (context, _, __) {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                width: 75,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<GamePoolBloc>().add(
                              GamePoolEvent.setWhitePromotedPiece(
                                promotedPiece: PromotedPiece.queen,
                              ),
                            );
                        context.navigator.pop();
                      },
                      icon: SizedBox(
                        width: buttonSize,
                        height: buttonSize,
                        child: Image.asset(
                          ChessIcons.newQueen,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<GamePoolBloc>().add(
                              GamePoolEvent.setWhitePromotedPiece(
                                promotedPiece: PromotedPiece.rock,
                              ),
                            );
                        context.navigator.pop();
                      },
                      icon: SizedBox(
                        width: buttonSize,
                        height: buttonSize,
                        child: Image.asset(
                          ChessIcons.newRock,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<GamePoolBloc>().add(
                              GamePoolEvent.setWhitePromotedPiece(
                                promotedPiece: PromotedPiece.bishop,
                              ),
                            );
                        context.navigator.pop();
                      },
                      icon: SizedBox(
                        width: buttonSize,
                        height: buttonSize,
                        child: Image.asset(
                          ChessIcons.newBishop,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<GamePoolBloc>().add(
                              GamePoolEvent.setWhitePromotedPiece(
                                promotedPiece: PromotedPiece.knight,
                              ),
                            );
                        context.navigator.pop();
                      },
                      icon: SizedBox(
                        width: buttonSize,
                        height: buttonSize,
                        child: Image.asset(
                          ChessIcons.newKnight,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
