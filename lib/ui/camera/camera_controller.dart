import 'package:face_commute/base/base.dart';
import 'package:face_commute/ui/camera/camera_bloc.dart';
import 'package:face_commute/ui/camera/state/camera_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final class CameraController extends BaseController<CameraBloc, CameraState> with BasePageMixin {
  CameraController(this.context);

  @override
  final BuildContext context;
}
