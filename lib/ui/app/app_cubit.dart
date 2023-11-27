import 'package:face_commute/module/module.dart';
import 'package:face_commute/ui/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class AppCubit extends Cubit<AppState> {
  AppCubit(super.initialState);

  factory AppCubit.empty() => AppCubit(AppState.empty());

  void toggleTheme() {
    debugPrint('[AppCubit] toggleTheme');
    return emit(
      AppState.empty().copyWith(
        platform: state.platform,
        brightness: state.brightness.toggle,
      ),
    );
  }
}
