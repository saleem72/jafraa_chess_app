//

import 'package:flutter/material.dart';
import 'package:jafraa_chess_app/configuration/extensions/build_context_extension.dart';

import 'board_background.dart';
import 'chess_pieces_view.dart';

class ChessBoard extends StatelessWidget {
  const ChessBoard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: context.mediaQuery.size.width,
        child: Stack(
          children: const [
            BoardBackground(),
            ChessPiecesView(),
          ],
        ));
  }
}
