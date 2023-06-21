//

import 'package:flutter/material.dart';

import 'app_icon_button.dart';

class PNGReaderToolBar extends StatelessWidget {
  const PNGReaderToolBar({
    super.key,
    required this.onEnd,
    required this.onReload,
    required this.onBackMove,
    required this.onNextMove,
  });
  final VoidCallback onEnd;
  final VoidCallback onReload;
  final VoidCallback onBackMove;
  final VoidCallback onNextMove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              AppIconButton(
                onPressed: onEnd,
                icon: Icons.logout,
                label: 'End',
              ),
              AppIconButton(
                onPressed: onReload,
                icon: Icons.restart_alt_outlined,
                label: 'reload',
              ),
              AppIconButton(
                onPressed: onBackMove,
                icon: Icons.arrow_back_ios,
                label: 'Back',
              ),
              AppIconButton(
                onPressed: onNextMove,
                icon: Icons.arrow_forward_ios,
                label: 'Forward',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
