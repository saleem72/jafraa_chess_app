//

import 'package:flutter/material.dart';
import 'package:jafraa_chess_app/configuration/extensions/build_context_extension.dart';

import '../../../../core/domain/models/chess_move.dart';
import '../../../../core/domain/models/chess_piece_properties.dart';

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
