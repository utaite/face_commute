import 'package:face_commute/base/base.dart';
import 'package:face_commute/module/module.dart';
import 'package:face_commute/ui/app/app_cubit.dart';
import 'package:face_commute/ui/app/app_state.dart';
import 'package:face_commute/ui/camera/camera_bloc.dart';
import 'package:face_commute/ui/camera/camera_page.dart';
import 'package:face_commute/ui/main/dialog/main_dialog.dart';
import 'package:face_commute/ui/main/dialog/main_dialog_cubit.dart';
import 'package:face_commute/ui/main/dialog/main_dialog_state.dart';
import 'package:face_commute/ui/main/main_bloc.dart';
import 'package:face_commute/ui/main/main_event.dart';
import 'package:face_commute/ui/main/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

base class AppController extends BaseController<AppCubit, AppState> {
  AppController(this.context);

  @override
  final BuildContext context;

  Map<String, WidgetBuilder> get routes => {
        '/${Routes.camera.name}': (context) => MultiBlocProvider(
              providers: [
                BlocProvider<CameraBloc>.value(
                  value: BlocProvider.of(context),
                ),
              ],
              child: const CameraPage(),
            ),
        '/${Routes.main.name}': (context) => MultiBlocProvider(
              providers: [
                BlocProvider<MainBloc>(
                  create: (context) => context.singleton(MainBloc.empty)
                    ..add(
                      GetEvent(
                        onTap: (program) async => showCupertinoModalPopup<DateTime>(
                          context: context,
                          builder: (context) => BlocProvider<MainDialogCubit>(
                            create: (context) => MainDialogCubit(
                              MainDialogState.empty().copyWith(
                                isTime: program.title == '스마트생산개론',
                                isLocation: program.title == '스마트생산개론',
                                program: program,
                              ),
                            ),
                            child: const MainDialog(),
                          ),
                        ),
                      ),
                    ),
                ),
              ],
              child: const MainPage(),
            ),
      };
}
