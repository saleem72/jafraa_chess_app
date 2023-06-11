//

import 'package:flutter/material.dart';

import '../../../../configuration/theme/colors.dart';
import '../../domain/helpers/chess_helper.dart';

class BoardBackground extends StatelessWidget {
  const BoardBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
        ),
        itemCount: 64,
        itemBuilder: (context, index) {
          final isLight = ChessHelper.isLightSquare(index);
          // final label = ChessHelper.fileLabel(index);
          // final file = ChessHelper.getFile(index);
          // final rank = ChessHelper.getRank(index);
          return AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: isLight ? AppColors.darkSquare : AppColors.lightSquare,
              // child: Column(
              //   children: [
              //     Text('$label:$rank'),
              //     Text(
              //       ChessHelper.getIndex(file: file, rank: rank).toString(),
              //     ),
              //   ],
              // ),
            ),
          );
        },
      ),
    );
  }
}
