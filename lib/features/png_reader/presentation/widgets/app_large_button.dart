//

import 'package:flutter/material.dart';
import 'package:jafraa_chess_app/configuration/extensions/build_context_extension.dart';

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
      onPressed: () => onTap(),
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
