import 'package:face_commute/base/base.dart';
import 'package:face_commute/ui/camera/model/camera_model.dart';

base class CameraState extends BaseModel with BaseState {
  const CameraState({
    required this.model,
    required this.isListen,
  });

  factory CameraState.empty() => _empty;

  final CameraModel model;
  @override
  final bool isListen;

  static final CameraState _empty = CameraState(
    model: CameraModel.empty(),
    isListen: false,
  );

  @override
  bool get isEmpty => this == _empty;

  @override
  CameraState copyWith({
    CameraModel? model,
    bool? isListen,
  }) =>
      CameraState(
        model: model ?? this.model,
        isListen: isListen ?? this.isListen,
      );

  @override
  List<Object?> get props => [model, isListen];
}
