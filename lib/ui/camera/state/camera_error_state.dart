import 'package:face_commute/base/base.dart';
import 'package:face_commute/ui/camera/model/camera_model.dart';
import 'package:face_commute/ui/camera/state/camera_state.dart';

final class CameraErrorState extends CameraState with BaseState {
  const CameraErrorState({
    required super.model,
    required this.error,
    required super.isListen,
  });

  factory CameraErrorState.empty() => _empty;

  final String error;

  static final CameraErrorState _empty = CameraErrorState(
    model: CameraModel.empty(),
    error: '',
    isListen: false,
  );

  @override
  bool get isEmpty => this == _empty;

  @override
  CameraErrorState copyWith({
    CameraModel? model,
    String? error,
    bool? isListen,
  }) =>
      CameraErrorState(
        model: model ?? this.model,
        error: error ?? this.error,
        isListen: isListen ?? this.isListen,
      );

  @override
  List<Object?> get props => [model, error, isListen];
}
