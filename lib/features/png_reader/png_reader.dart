//

import 'package:flutter/material.dart';
import 'package:jafraa_chess_app/configuration/assets/chess_components.dart';
import 'package:jafraa_chess_app/configuration/extensions/build_context_extension.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_game.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_notation.dart';

class PngReaderScreen extends StatefulWidget {
  const PngReaderScreen({super.key});

  @override
  State<PngReaderScreen> createState() => _PngReaderScreenState();
}

class _PngReaderScreenState extends State<PngReaderScreen> {
  TextEditingController _controller = TextEditingController();

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
            const SizedBox(height: 44),
            Expanded(
              child: TextField(
                controller: _controller,
                style: context.textTheme.titleMedium?.copyWith(
                  color: Colors.black87,
                ),
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'put your png here...',
                  hintStyle: context.textTheme.titleMedium?.copyWith(
                    color: Colors.black54,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 44),
            TextButton(
              onPressed: () => _decode(_controller.text),
              child: const Text('Decode'),
            ),
          ],
        ),
      ),
    );
  }

  _decode(String value) {
    // final text = value.trim();
    // if (text.isNotEmpty) {
    //   final list = NotationsList.fromString(text);
    //   setState(() {
    //     steps = list;
    //   });
    // }

    final game = ChessGame.fromString(value);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(step.line),
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
