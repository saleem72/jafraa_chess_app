//

import 'package:flutter/material.dart';
import 'package:jafraa_chess_app/configuration/extensions/build_context_extension.dart';

import '../../../../configuration/assets/chess_components.dart';

class OtherPlayer extends StatelessWidget {
  const OtherPlayer({
    super.key,
    this.description,
    required this.playerName,
  });

  final String playerName;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Container(
                // width: 30,
                // height: 30,
                decoration: BoxDecoration(
                  color: context.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                  // image: const DecorationImage(
                  //   image: AssetImage(AppAssets.boy),
                  // ),
                ),
                child: Image.asset(AppAssets.boy),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        playerName,
                        style: context.textTheme.bodyMedium
                            ?.copyWith(color: context.colorScheme.onSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (description != null)
                        Text(
                          ' (${description!})',
                          style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onSecondary
                                  .withOpacity(0.6)),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
