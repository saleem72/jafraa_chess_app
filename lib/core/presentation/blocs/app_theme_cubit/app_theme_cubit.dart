//
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_coordinate.dart';
import 'package:jafraa_chess_app/core/domain/models/chess_piece.dart';

part 'app_theme_state.dart';

class AppThemeCubit extends Cubit<ThemeMode> {
  AppThemeCubit() : super(ThemeMode.system);

  setThemeMode(ThemeMode mode) {
    emit(mode);
  }
}
