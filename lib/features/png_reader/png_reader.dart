//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jafraa_chess_app/configuration/extensions/build_context_extension.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_game.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_notation.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/presentation/game_pool_bloc/game_pool_bloc.dart';
import 'package:jafraa_chess_app/features/png_reader/png_details.dart';
import 'package:jafraa_chess_app/features/png_reader/presentation/widgets/app_large_button.dart';
import 'package:jafraa_chess_app/pngs/saved_games.dart';

import 'presentation/widgets/app_text_editor.dart';

class PngReaderScreen extends StatefulWidget {
  const PngReaderScreen({super.key});

  @override
  State<PngReaderScreen> createState() => _PngReaderScreenState();
}

class _PngReaderScreenState extends State<PngReaderScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<ChessNotation> steps = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(
          children: [
            const SizedBox(height: 24),
            _header(context),
            const SizedBox(height: 16),
            _textEditor(context),
            const SizedBox(height: 16),
            _deodeButton(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _deodeButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppLargeButton(
        onTap: () => _decode(context, _controller.text),
        label: 'Decode',
      ),
    );
  }

  Widget _textEditor(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AppTextEditor(controller: _controller),
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
          const Spacer(),
          TextButton(
            onPressed: () => _controller.text = SavedGames.game1,
            child: Text(
              'G1',
              style: context.textTheme.titleMedium?.copyWith(
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _controller.text = SavedGames.game2,
            child: Text(
              'G2',
              style: context.textTheme.titleMedium?.copyWith(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _decode(BuildContext context, String value) {
    if (value.trim().isEmpty) {
      return;
    }

    final game = ChessGame.fromString(value);
    context.read<GamePoolBloc>().add(GamePoolEvent.resetBoard());
    context.navigator
        .push(MaterialPageRoute(builder: (context) => PNGDetails(game: game)));
  }
}
