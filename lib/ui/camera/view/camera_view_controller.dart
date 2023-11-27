import 'dart:async';

import 'package:camera/camera.dart';
import 'package:face_commute/base/base.dart';
import 'package:face_commute/module/module.dart';
import 'package:face_commute/ui/camera/camera_bloc.dart';
import 'package:face_commute/ui/camera/camera_event.dart';
import 'package:face_commute/ui/camera/state/camera_state.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

final class CameraViewController extends BaseController<CameraBloc, CameraState> {
  CameraViewController(this.context);

  @override
  final BuildContext context;

  Future<void> onInit(CameraController cameraController, PublishSubject<CameraImage> cameraImageSubject) async {
    try {
      await cameraController.initialize();
      await cameraController.startImageStream(cameraImageSubject.add);

      bloc.add(
        InitialEvent(
          state: CameraState.empty().copyWith(
            model: state.model.copyWith(
              cameraStatus: CameraStatus.initial,
            ),
          ),
        ),
      );
    } on CameraException {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('설정에서 카메라를 활성화해주세요.'),
          ),
        );
      }

      await openAppSettings();
      super.pop();
    }
  }
}
