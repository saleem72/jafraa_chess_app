//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../game_pool_bloc/game_pool_bloc.dart';

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
