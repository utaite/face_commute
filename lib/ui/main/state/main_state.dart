import 'package:face_commute/base/base.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

base class MainState extends BaseModel with BaseState {
  const MainState({
    required this.markers,
    required this.isGet,
    required this.isListen,
  });

  factory MainState.empty() => _empty;

  final Set<Marker> markers;
  @override
  final bool isGet;
  @override
  final bool isListen;

  static const MainState _empty = MainState(
    markers: {},
    isGet: false,
    isListen: false,
  );

  @override
  bool get isEmpty => this == _empty;

  @override
  MainState copyWith({
    Set<Marker>? markers,
    bool? isGet,
    bool? isListen,
  }) =>
      MainState(
        markers: markers ?? this.markers,
        isGet: isGet ?? this.isGet,
        isListen: isListen ?? this.isListen,
      );

  @override
  List<Object?> get props => [markers, isGet, isListen];
}
