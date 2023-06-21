//

import 'package:flutter/material.dart';
import 'package:jafraa_chess_app/configuration/extensions/build_context_extension.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.onPressed,
    this.label,
    required this.icon,
  });

  final VoidCallback onPressed;
  final String? label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(),
      child: label != null
          ? Column(
              children: [
                Icon(icon),
                Text(
                  label!,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.primary,
                  ),
                ),
              ],
            )
          : Icon(icon),
    );
  }
}
