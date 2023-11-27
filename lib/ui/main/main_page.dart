import 'package:face_commute/ui/main/main_bloc.dart';
import 'package:face_commute/ui/main/main_controller.dart';
import 'package:face_commute/ui/main/state/main_state.dart';
import 'package:face_commute/ui/page/page_cubit.dart';
import 'package:face_commute/ui/page/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension on BuildContext {
  MainController get controller => MainController(this);
}

final class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('[MainFragment] build: ${context.controller.state}');
    return MultiBlocListener(
      listeners: [
        BlocListener<PageCubit, PageState>(
          listenWhen: context.controller.listenWhenPage,
          listener: context.controller.onListenPage,
        ),
      ],
      child: Scaffold(
        body: BlocSelector<MainBloc, MainState, Set<Marker>>(
          selector: (state) => state.markers,
          builder: (context, markers) => GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.2843727, 127.0443767),
              zoom: 17,
            ),
            markers: markers,
            myLocationEnabled: true,
          ),
        ),
      ),
    );
  }
}
