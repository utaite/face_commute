import 'package:face_commute/base/base.dart';
import 'package:face_commute/model/model.dart';
import 'package:face_commute/module/module.dart';

final class PageState extends BaseModel with BaseState {
  const PageState({
    required this.isPush,
    required this.pages,
  });

  factory PageState.empty() => _empty;

  final bool isPush;

  final Iterable<RouteModel> pages;

  String get current => (pages.lastOrNull?.routeName).elvis;

  static const PageState _empty = PageState(
    isPush: false,
    pages: Iterable.empty(),
  );

  @override
  bool get isEmpty => this == _empty;

  @override
  PageState copyWith({
    bool? isPush,
    Iterable<RouteModel>? pages,
  }) =>
      PageState(
        isPush: isPush ?? this.isPush,
        pages: pages ?? this.pages,
      );

  @override
  List<Object?> get props => [isPush, pages];
}
