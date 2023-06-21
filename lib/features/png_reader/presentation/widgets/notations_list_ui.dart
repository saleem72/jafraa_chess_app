//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../notations_list_bloc/notations_list_bloc.dart';
import 'chess_notation_ui.dart';

class NotationsListUI extends StatelessWidget {
  const NotationsListUI({
    super.key,
    required this.controller,
  });

  final ScrollController controller;
  // final List<ChessNotation> notations;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotationsListBloc, NotationsListState>(
      builder: (context, state) {
        return _buildList(context, state);
      },
    );
  }

  Widget _buildList(BuildContext context, NotationsListState state) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: state.moves.length,
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final move = state.moves[index];
          return ChessNotationUI(
            move: move,
            isSelected: state.selectedMove == index,
          );
        },
      ),
    );
  }
}
