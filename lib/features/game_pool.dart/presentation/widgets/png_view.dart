//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_piece.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/domain/extensions/chess_piece_list_extension.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/domain/helpers/chess_helper.dart';

import '../../../png_reader/presentation/notations_list_bloc/notations_list_bloc.dart';

class PNGView extends StatelessWidget {
  const PNGView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotationsListBloc, NotationsListState>(
      builder: (context, state) {
        return _buildGrid(context, state);
      },
    );
  }

  GridView _buildGrid(BuildContext context, NotationsListState state) {
    final selectedIndex = state.selectedMove;

    final List<ChessPiece> pieces = selectedIndex == -1
        ? ChessHelper.initialPieces()
        : state.boards[selectedIndex];
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

        return AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              Container(
                child: piece == null
                    ? const SizedBox.shrink()
                    : Image.asset(
                        piece.icon,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
