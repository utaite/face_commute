import 'package:face_commute/base/base.dart';
import 'package:face_commute/model/model.dart';
import 'package:face_commute/ui/main/state/main_state.dart';
import 'package:flutter/foundation.dart';

abstract base class MainEvent extends BaseEvent {}

final class InitialEvent extends MainEvent {
  InitialEvent({
    this.state,
  });

  final MainState? state;

  @override
  List<Object?> get props => [state];
}

final class GetEvent extends MainEvent {
  GetEvent({
    required this.onTap,
  });

  final ValueChanged<ProgramModel> onTap;

  @override
  List<Object?> get props => [onTap];
}
