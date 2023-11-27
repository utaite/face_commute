import 'package:camera/camera.dart';
import 'package:face_commute/base/base.dart';
import 'package:face_commute/module/module.dart';

final class CameraModel extends BaseModel {
  const CameraModel({
    required this.cameraStatus,
    required this.cameraDescription,
  });

  factory CameraModel.empty() => _empty;

  final CameraStatus cameraStatus;
  final CameraDescription cameraDescription;

  static const CameraModel _empty = CameraModel(
    cameraStatus: CameraStatus.empty,
    cameraDescription: CameraDescription(
      name: '',
      lensDirection: CameraLensDirection.front,
      sensorOrientation: 0,
    ),
  );

  @override
  bool get isEmpty => this == _empty;

  @override
  CameraModel copyWith({
    CameraStatus? cameraStatus,
    CameraDescription? cameraDescription,
  }) =>
      CameraModel(
        cameraStatus: cameraStatus ?? this.cameraStatus,
        cameraDescription: cameraDescription ?? this.cameraDescription,
      );

  @override
  List<Object?> get props => [cameraStatus, cameraDescription];
}
