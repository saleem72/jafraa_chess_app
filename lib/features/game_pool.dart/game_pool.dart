//

import 'package:flutter/material.dart';
import 'package:jafraa_chess_app/configuration/extensions/build_context_extension.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/domain/helpers/chess_helper.dart';

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
          // myWidget(context),
          SizedBox(
              height: context.mediaQuery.size.width,
              child: Stack(
                children: const [
                  BoardBackground(),
                  ChessPiecesView(),
                ],
              )),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
