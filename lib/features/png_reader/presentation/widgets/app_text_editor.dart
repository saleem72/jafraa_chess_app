//

import 'package:flutter/material.dart';
import 'package:jafraa_chess_app/configuration/extensions/build_context_extension.dart';

class AppTextEditor extends StatelessWidget {
  const AppTextEditor({
    super.key,
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'put your png here...',
          hintStyle: context.textTheme.titleMedium?.copyWith(
            color: context.colorScheme.onSecondaryContainer,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
