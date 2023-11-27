import 'package:face_commute/base/base.dart';
import 'package:face_commute/ui/main/main_bloc.dart';
import 'package:face_commute/ui/main/state/main_state.dart';
import 'package:flutter/cupertino.dart';

final class MainController extends BaseController<MainBloc, MainState> with BasePageMixin {
  MainController(this.context);

  @override
  final BuildContext context;
}
