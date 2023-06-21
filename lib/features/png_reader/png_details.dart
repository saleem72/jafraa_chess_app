//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jafraa_chess_app/configuration/extensions/build_context_extension.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_game.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/presentation/game_pool_bloc/game_pool_bloc.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/presentation/widgets/game_pool_widgets.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/presentation/widgets/png_view.dart';

import '../game_pool.dart/presentation/widgets/board_background.dart';
import 'presentation/notations_list_bloc/notations_list_bloc.dart';
import 'presentation/widgets/notations_list_ui.dart';
import 'presentation/widgets/png_reader_tool_bar.dart';

class PNGDetails extends StatelessWidget {
  const PNGDetails({
    super.key,
    required this.game,
  });
  final ChessGame game;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotationsListBloc>(
      create: (context) => NotationsListBloc(game: game),
      child: PNGDetailsContent(game: game),
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
                PNGView(),
              ],
            ),
          ),
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
      child: PNGReaderToolBar(
        onEnd: () => context.navigator.pop(),
        onReload: () => _reload(context),
        onBackMove: () => _previousMove(context),
        onNextMove: () => _nextMove(context),
      ),
    );
  }

  _nextMove(BuildContext context) {
    final move = context.read<NotationsListBloc>().nextMove();
    if (move != null) {
      _controller.animateTo(
        context.read<NotationsListBloc>().offsetFor(move),
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
      );
    }
  }

  _previousMove(BuildContext context) {
    final move = context.read<NotationsListBloc>().previousMove();
    if (move != null) {
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
