import 'package:face_commute/model/model.dart';
import 'package:face_commute/ui/page/page_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class PageCubit extends Cubit<PageState> {
  PageCubit(super.initialState);

  factory PageCubit.empty() => PageCubit(PageState.empty());

  void toNamed(RouteModel route) => emit(
        PageState.empty().copyWith(
          isPush: true,
          pages: [...state.pages, route],
        ),
      );

  void offNamed(RouteModel route) => emit(
        PageState.empty().copyWith(
          pages: [...state.pages.take(state.pages.length - 1), route],
        ),
      );

  void offAllNamed(RouteModel route) => emit(
        PageState.empty().copyWith(
          pages: [route],
        ),
      );

  void pop() => emit(
        PageState.empty().copyWith(
          pages: [...state.pages.take(state.pages.length - 1)],
        ),
      );
}
