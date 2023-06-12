//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jafraa_chess_app/configuration/extensions/build_context_extension.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/presentation/game_pool_bloc/game_pool_bloc.dart';

import 'presentation/widgets/board_background.dart';
import 'presentation/widgets/chess_pieces_view.dart';
import 'presentation/widgets/other_player.dart';

class GamePool extends StatelessWidget {
  const GamePool({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          const Spacer(flex: 1),
          const OtherPlayer(),
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
          const SizedBox(height: 16),
          const BlackDeadPiecesList(),
          const SizedBox(height: 16),

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
}

class WhiteDeadPiecesList extends StatelessWidget {
  const WhiteDeadPiecesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamePoolBloc, GamePoolState>(
      buildWhen: (previous, current) =>
          current.whiteDeadPieces != previous.whiteDeadPieces,
      builder: (context, state) {
        return SizedBox(
          height: 32,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.whiteDeadPieces.length,
            itemBuilder: (context, index) {
              return Image.asset(
                state.whiteDeadPieces[index].icon,
                color: Colors.white,
              );
            },
          ),
        );
      },
    );
  }
}

class BlackDeadPiecesList extends StatelessWidget {
  const BlackDeadPiecesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamePoolBloc, GamePoolState>(
      buildWhen: (previous, current) =>
          current.blackDeadPieces != previous.blackDeadPieces,
      builder: (context, state) {
        return SizedBox(
          height: 32,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.blackDeadPieces.length,
            itemBuilder: (context, index) {
              return Image.asset(
                state.blackDeadPieces[index].icon,
                color: Colors.black,
              );
            },
          ),
        );
      },
    );
  }
}
