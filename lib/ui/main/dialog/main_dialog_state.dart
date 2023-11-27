import 'package:face_commute/base/base.dart';
import 'package:face_commute/model/model.dart';

final class MainDialogState extends BaseModel with BaseState {
  const MainDialogState({
    required this.program,
    required this.isTime,
    required this.isLocation,
  });

  factory MainDialogState.empty() => _empty;

  final ProgramModel program;
  final bool isTime;
  final bool isLocation;

  static final MainDialogState _empty = MainDialogState(
    program: ProgramModel.empty(),
    isTime: false,
    isLocation: false,
  );

  @override
  bool get isEmpty => this == _empty;

  @override
  bool get isActive => isTime && isLocation;

  @override
  MainDialogState copyWith({
    ProgramModel? program,
    bool? isTime,
    bool? isLocation,
  }) =>
      MainDialogState(
        program: program ?? this.program,
        isTime: isTime ?? this.isTime,
        isLocation: isLocation ?? this.isLocation,
      );

  @override
  List<Object?> get props => [program, isTime, isLocation];
}
