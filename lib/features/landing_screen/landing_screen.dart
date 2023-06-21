//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jafraa_chess_app/configuration/extensions/build_context_extension.dart';
import 'package:jafraa_chess_app/configuration/routing/app_screen.dart';
import 'package:jafraa_chess_app/core/presentation/blocs/app_theme_cubit/app_theme_cubit.dart';

import '../game_pool.dart/presentation/game_pool_bloc/game_pool_bloc.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});
  void toggleThemeMode(BuildContext context) {
    final cubit = context.read<AppThemeCubit>();
    final mode = context.colorScheme.brightness;
    if (mode == Brightness.light) {
      cubit.setThemeMode(ThemeMode.dark);
    } else {
      cubit.setThemeMode(ThemeMode.light);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            AppButton(
              onTap: () => context.navigator.pushNamed(AppScreen.pngScreen),
              label: 'PNG Reader',
            ),
            const SizedBox(height: 24),
            AppButton(
              onTap: () {
                context.read<GamePoolBloc>().add(GamePoolEvent.resetBoard());
                return context.navigator.pushNamed(AppScreen.gamePool);
              },
              label: 'Game pool',
            ),
          ],
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.onTap, required this.label});
  final Function() onTap;
  final String label;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.transparent,
        elevation: 4,
        child: InkWell(
          splashColor: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: context.textTheme.titleMedium
                      ?.copyWith(color: context.colorScheme.onPrimary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
