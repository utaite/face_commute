import 'package:camera/camera.dart';
import 'package:face_commute/base/base.dart';
import 'package:face_commute/model/model.dart';
import 'package:face_commute/ui/camera/camera_bloc.dart';
import 'package:face_commute/ui/camera/camera_event.dart' as camera;
import 'package:face_commute/ui/camera/model/camera_model.dart';
import 'package:face_commute/ui/camera/state/camera_state.dart';
import 'package:face_commute/ui/main/dialog/main_dialog_cubit.dart';
import 'package:face_commute/ui/main/dialog/main_dialog_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class MainDialogController extends BaseController<MainDialogCubit, MainDialogState> with BasePageMixin {
  MainDialogController(this.context);

  @override
  final BuildContext context;

  Future<void> onPressed() async {
    final cameras = await availableCameras();
    if (context.mounted) {
      context.read<CameraBloc>().add(
            camera.InitialEvent(
              state: CameraState.empty().copyWith(
                model: CameraModel.empty().copyWith(
                  cameraDescription: cameras.where((x) => x.lensDirection == CameraLensDirection.front && x.sensorOrientation == 90).firstOrNull ??
                      cameras.where((x) => x.lensDirection == CameraLensDirection.front).firstOrNull,
                ),
              ),
            ),
          );
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

      super.toNamedPage(RouteModel.camera());
    }
  }
}
