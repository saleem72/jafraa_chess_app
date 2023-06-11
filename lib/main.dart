import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'configuration/theme/app_theme.dart';
import 'core/presentation/blocs/app_theme_cubit/app_theme_cubit.dart';
import 'features/game_pool.dart/game_pool.dart';
import 'features/game_pool.dart/presentation/game_pool_bloc/game_pool_bloc.dart';

//
// <item name="android:windowLayoutInDisplayCutoutMode">shortEdges</item>

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hideSystemNavigationBar();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppThemeCubit(),
        ),
        BlocProvider(
          create: (context) => GamePoolBloc(),
        ),
      ],
      child: const JafraaChess(),
    );
  }
}

class JafraaChess extends StatelessWidget {
  const JafraaChess({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode:
          context.select<AppThemeCubit, ThemeMode>((value) => value.state),
      home: const GamePool(),
    );
  }
}
