import 'package:face_commute/module/module.dart';
import 'package:face_commute/ui/camera/camera_controller.dart';
import 'package:face_commute/ui/camera/view/camera_view.dart';
import 'package:face_commute/ui/page/page_cubit.dart';
import 'package:face_commute/ui/page/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension on BuildContext {
  CameraController get controller => CameraController(this);
}

final class CameraPage extends StatelessWidget {
  const CameraPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('[CameraFragment] build: ${context.controller.state}');
    return MultiBlocListener(
      listeners: [
        BlocListener<PageCubit, PageState>(
          listenWhen: context.controller.listenWhenPage,
          listener: context.controller.onListenPage,
        ),
      ],
      child: Scaffold(
        body: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            const CameraView().sliverFill,
          ],
        ),
      ),
    );
  }
}
