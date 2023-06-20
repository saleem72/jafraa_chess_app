//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jafraa_chess_app/configuration/extensions/build_context_extension.dart';
import 'package:jafraa_chess_app/configuration/routing/screens.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_game.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_piece_properties.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/presentation/game_pool_bloc/game_pool_bloc.dart';

import '../../core/domain/models/chess_move.dart';
import '../game_pool.dart/presentation/widgets/black_dead_pieces_list.dart';
import '../game_pool.dart/presentation/widgets/board_background.dart';
import '../game_pool.dart/presentation/widgets/chess_pieces_view.dart';
import '../game_pool.dart/presentation/widgets/other_player.dart';
import '../game_pool.dart/presentation/widgets/white_dead_pieces_list.dart';
import 'presentation/notations_list_bloc/notations_list_bloc.dart';

class PNGDetails extends StatefulWidget {
  const PNGDetails({
    super.key,
    required this.game,
  });
  final ChessGame game;

  @override
  State<PNGDetails> createState() => _PNGDetailsState();
}

class _PNGDetailsState extends State<PNGDetails> {
  // late NotationsListBloc _bloc;

  // @override
  // void initState() {
  //   super.initState();
  //   _bloc = NotationsListBloc(game: widget.game);
  //   _bloc.add(NotationsListEvent.clearSelected());

  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotationsListBloc>(
      create: (context) => NotationsListBloc(game: widget.game),
      child: PNGDetailsContent(game: widget.game),
    );
  }
}

class PNGDetailsContent extends StatefulWidget {
  const PNGDetailsContent({
    super.key,
    required this.game,
  });
  final ChessGame game;

  @override
  State<PNGDetailsContent> createState() => _PNGDetailsContentState();
}

class _PNGDetailsContentState extends State<PNGDetailsContent> {
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.bottomCenter,
        children: [
          _content(context),
          _actions(context),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          NotationsListUI(controller: _controller),
          OtherPlayer(
            playerName: widget.game.black ?? '',
            description: widget.game.blackElo,
          ),
          const SizedBox(height: 8),
          const WhiteDeadPiecesList(),
          const SizedBox(height: 8),
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
          OtherPlayer(
            playerName: widget.game.white ?? '',
            description: widget.game.whiteElo,
          ),
        ],
      ),
    );
  }

  Widget _actions(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 64,
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 2,
                  spreadRadius: 1,
                  offset: const Offset(0, -1),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => context.navigator.pop(),
                  child: Column(
                    children: [
                      const Icon(Icons.logout),
                      Text(
                        'End',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _reload(context),
                  child: Column(
                    children: [
                      const Icon(Icons.restart_alt_outlined),
                      Text(
                        'reload',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Column(
                    children: [
                      const Icon(Icons.arrow_back_ios),
                      Text(
                        'back',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _doMove(context),
                  child: Column(
                    children: [
                      const Icon(Icons.arrow_forward_ios),
                      Text(
                        'forward',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _doMove(BuildContext context) {
    final move = context.read<NotationsListBloc>().nextMove();
    if (move != null) {
      context.read<GamePoolBloc>().add(GamePoolEvent.doMove(move: move));

      _controller.animateTo(
        context.read<NotationsListBloc>().offsetFor(move),
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
      );
    }
  }

  _reload(BuildContext context) {
    context.read<GamePoolBloc>().add(GamePoolEvent.resetBoard());
    context.read<NotationsListBloc>().add(NotationsListEvent.clearSelected());
    _controller.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
    );
  }
}

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

class ChessNotationUI extends StatelessWidget {
  const ChessNotationUI({
    super.key,
    required this.move,
    required this.isSelected,
  });

  final ChessMove move;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      alignment: Alignment.centerLeft,
      child: move.color == ChessPieceColor.white
          ? SizedBox(
              width: 68,
              child: Row(
                children: [
                  Text('${move.number}. '),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? context.colorScheme.primary : null,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      child: move.isCastling
                          ? const Text('o-o')
                          : Text(
                              move.toString(),
                              maxLines: 1,
                            ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: isSelected ? context.colorScheme.primary : null,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 40,
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child: move.isCastling
                  ? const Text('o-o')
                  : Text(
                      move.toString(),
                      maxLines: 1,
                    ),
            ),
    );
  }
}
