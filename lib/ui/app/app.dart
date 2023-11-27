import 'package:face_commute/model/model.dart';
import 'package:face_commute/module/module.dart';
import 'package:face_commute/ui/app/app_controller.dart';
import 'package:face_commute/ui/app/app_cubit.dart';
import 'package:face_commute/ui/app/app_state.dart';
import 'package:face_commute/ui/camera/camera_bloc.dart';
import 'package:face_commute/ui/page/page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension on BuildContext {
  AppController get controller => AppController(this);
}

final class App extends StatelessWidget {
  const App({
    required this.initialRoute,
    super.key,
    this.brightness,
    this.platform,
  });

  final RouteModel initialRoute;
  final Brightness? brightness;
  final TargetPlatform? platform;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<PageCubit>(
            create: (context) => PageCubit.empty()..toNamed(initialRoute),
          ),
          BlocProvider<AppCubit>(
            create: (context) => context.singleton(
              () => AppCubit(
                AppState.empty().copyWith(
                  brightness: brightness,
                  platform: platform,
                ),
              ),
            ),
          ),
          BlocProvider<CameraBloc>(
            create: (context) => context.singleton(CameraBloc.empty),
          ),
        ],
        child: BlocSelector<AppCubit, AppState, Brightness>(
          selector: (state) => state.brightness,
          builder: (context, brightness) {
            SystemChrome.setSystemUIOverlayStyle(brightness.statusBarStyle);

            return MaterialApp(
              title: '출퇴근대장',
              initialRoute: initialRoute.routeName,
              routes: context.controller.routes,
              localizationsDelegates: const [],
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      );
}
