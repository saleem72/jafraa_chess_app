//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../game_pool_bloc/game_pool_bloc.dart';

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
