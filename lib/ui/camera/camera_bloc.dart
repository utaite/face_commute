import 'package:face_commute/ui/camera/camera_event.dart';
import 'package:face_commute/ui/camera/state/camera_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc({
    required CameraState initialState,
  }) : super(initialState) {
    on<InitialEvent>(_onInitial);
  }

  factory CameraBloc.empty({CameraState? initialState}) => CameraBloc(
        initialState: initialState ?? CameraState.empty(),
      );

  void _onInitial(InitialEvent event, Emitter<CameraState> emit) {
    debugPrint('[CameraBloc] _onInitial: $event');
    return emit(event.state ?? CameraState.empty());
  }
}
