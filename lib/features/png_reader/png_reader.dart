//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jafraa_chess_app/configuration/assets/chess_components.dart';
import 'package:jafraa_chess_app/configuration/extensions/build_context_extension.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_game.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_notation.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/presentation/game_pool_bloc/game_pool_bloc.dart';
import 'package:jafraa_chess_app/features/png_reader/png_details.dart';
import 'package:jafraa_chess_app/pngs/game1.dart';

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
            Container(
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
                    onPressed: () => _controller.text = game1,
                    child: Text(
                      'G1',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _controller.text = game2,
                    child: Text(
                      'G2',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: context.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _controller,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onSecondaryContainer,
                    ),
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'put your png here...',
                      hintStyle: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.onSecondaryContainer,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextButton(
                onPressed: () => _decode(context, _controller.text),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: context.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Decode',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
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

class AppLargeButton extends StatelessWidget {
  const AppLargeButton({
    super.key,
    required this.onTap,
    required this.label,
  });
  final VoidCallback onTap;
  final String label;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: context.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colorScheme.onSecondaryContainer,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class ChessMoveUI extends StatelessWidget {
  const ChessMoveUI({
    super.key,
    required this.step,
  });

  final ChessNotation step;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Original: ${step.line}'),
            Text(step.whiteMove.toString()),
            Text(step.blackMove.toString()),
          ],
        ),
      ),
    );
  }
}

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.onAction,
  });
  final Function(String) onAction;
  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: SizedBox(
              height: 24,
              width: 24,
              child: Image.asset(ChessIcons.knightBlack),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _controller,
                style: context.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'put your png here...',
                  hintStyle: context.textTheme.titleMedium?.copyWith(
                    color: Colors.white60,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => widget.onAction(_controller.text),
            icon: const Icon(Icons.code),
          ),
        ],
      ),
    );
  }
}
