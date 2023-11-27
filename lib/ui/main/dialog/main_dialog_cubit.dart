import 'package:face_commute/ui/main/dialog/main_dialog_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class MainDialogCubit extends Cubit<MainDialogState> {
  MainDialogCubit(super.initialState);

  factory MainDialogCubit.empty() => MainDialogCubit(MainDialogState.empty());
}
