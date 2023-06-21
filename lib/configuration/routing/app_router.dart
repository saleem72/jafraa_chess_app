//

import 'package:flutter/material.dart';
import 'package:jafraa_chess_app/configuration/routing/app_screen.dart';
import 'package:jafraa_chess_app/configuration/routing/screens.dart';
import 'package:jafraa_chess_app/features/game_pool.dart/game_pool.dart';

import 'route_error_screen.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic>? generate(RouteSettings settings) {
    switch (settings.name) {
      case AppScreen.initial:
        return MaterialPageRoute(
          builder: (_) => const LandingScreen(),
        );
      case AppScreen.pngScreen:
        return MaterialPageRoute(
          builder: (_) => const PngReaderScreen(),
        );
      case AppScreen.gamePool:
        return MaterialPageRoute(
          builder: (_) => const GamePool(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => RouteErrorScreen(
            route: settings.name ?? '',
          ),
        );
    }
  }
}
