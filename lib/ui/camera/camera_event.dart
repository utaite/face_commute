import 'package:face_commute/base/base.dart';
import 'package:face_commute/ui/camera/state/camera_state.dart';

abstract base class CameraEvent extends BaseEvent {}

final class InitialEvent extends CameraEvent {
  InitialEvent({
    this.state,
  });

  final CameraState? state;

  @override
  List<Object?> get props => [state];
}
