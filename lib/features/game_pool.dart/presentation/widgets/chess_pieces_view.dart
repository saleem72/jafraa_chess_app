//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_coordinate.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/domain/helpers/chess_helper.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/presentation/game_pool_bloc/game_pool_bloc.dart';

class ChessPiecesView extends StatelessWidget {
  const ChessPiecesView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GamePoolBloc, GamePoolState>(
      builder: (context, state) {
        return _grid(context, state);
      },
      listener: (context, state) {},
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
            ? Colors.green
            : isItPossibleMove
                ? Colors.green.shade300
                : null;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (piece != null) {
              context
                  .read<GamePoolBloc>()
                  .add(GamePoolEvent.setSelected(piece: piece));
            } else {
              context.read<GamePoolBloc>().add(GamePoolEvent.clearSelected());
            }
          },
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(6),
                  color: color,
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
}
