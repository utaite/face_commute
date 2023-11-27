import 'package:face_commute/base/base.dart';
import 'package:face_commute/module/module.dart';

final class RouteModel extends BaseModel {
  const RouteModel({
    required this.routes,
    required this.title,
    required this.icon,
  });

  factory RouteModel.empty() => _empty;

  factory RouteModel.camera() => _camera;

  factory RouteModel.main() => _main;

  final Routes routes;

  final String title;

  final String icon;

  static const RouteModel _empty = RouteModel(
    routes: Routes.empty,
    title: '',
    icon: '',
  );

  static final RouteModel _camera = _empty.copyWith(
    routes: Routes.camera,
    title: '카메라',
  );

  static final RouteModel _main = _empty.copyWith(
    routes: Routes.main,
    title: '메인',
  );

  @override
  bool get isEmpty => this == _empty;

  String get routeName => '/${routes.name}';

  @override
  RouteModel copyWith({
    Routes? routes,
    String? title,
    String? icon,
  }) =>
      RouteModel(
        routes: routes ?? this.routes,
        title: title ?? this.title,
        icon: icon ?? this.icon,
      );

  @override
  List<Object?> get props => [routes, title, icon];
}
