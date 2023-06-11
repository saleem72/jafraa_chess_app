//

import 'package:flutter/material.dart';

import '../theme/colors.dart';

extension ContextVariables on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  NavigatorState get navigator => Navigator.of(this);
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  TextStyle? get fontTitle => textTheme.titleSmall?.copyWith(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      );
  TextStyle? get fontHugeBody => textTheme.bodyLarge?.copyWith(
        color: AppColors.secondaryText,
        fontSize: 20,
        fontWeight: FontWeight.w300,
        height: 1.2,
      );
}
