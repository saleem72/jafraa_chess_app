//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jafraa_chess_app/configuration/extensions/build_context_extension.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/presentation/game_pool_bloc/game_pool_bloc.dart';

import 'presentation/widgets/black_dead_pieces_list.dart';
import 'presentation/widgets/board_background.dart';
import 'presentation/widgets/chess_pieces_view.dart';
import 'presentation/widgets/other_player.dart';
import 'presentation/widgets/white_dead_pieces_list.dart';

class GamePool extends StatelessWidget {
  const GamePool({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          const SizedBox(height: 16),
          _header(context),
          const OtherPlayer(playerName: ''),
          const SizedBox(height: 16),
          const WhiteDeadPiecesList(),
          const SizedBox(height: 16),
          // myWidget(context),
          SizedBox(
              height: context.mediaQuery.size.width,
              child: Stack(
                children: const [
                  BoardBackground(),
                  ChessPiecesView(),
                ],
              )),
          const SizedBox(height: 8),
          const BlackDeadPiecesList(),
          const SizedBox(height: 8),

          TextButton(
            onPressed: () {
              context.read<GamePoolBloc>().add(GamePoolEvent.resetBoard());
            },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.colorScheme.onPrimary,
                ),
              ),
              child: Center(
                child: Text(
                  'Reset',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 56,
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.navigator.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
        ],
      ),
    );
  }
}
