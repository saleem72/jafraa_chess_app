//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jafraa_chess_app/configuration/extensions/build_context_extension.dart';
import 'package:jafraa_chess_app/core/presentation/blocs/app_theme_cubit/app_theme_cubit.dart';

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
      body: Column(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 48),
        child: FloatingActionButton(
          onPressed: () => toggleThemeMode(context),
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
