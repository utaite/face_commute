import 'package:face_commute/base/base.dart';
import 'package:face_commute/model/model.dart';
import 'package:face_commute/module/module.dart';
import 'package:face_commute/ui/page/page_cubit.dart';
import 'package:face_commute/ui/page/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin BasePageMixin on BaseMixin {
  PageCubit get _pageCubit => context.read();

  void toNamedPage(RouteModel route) {
    _pageCubit.toNamed(route);
  }

  void offNamedPage(RouteModel route) {
    _pageCubit.offNamed(route);
  }

  void offAllNamedPage(RouteModel route) {
    _pageCubit.offAllNamed(route);
  }

  bool listenWhenPage(PageState previous, PageState current) {
    if (current.pages.length == previous.pages.length) {
      final vec = List.generate(current.pages.length, (i) => current.pages[i] == previous.pages[i]);
      return !vec.removeLast() && vec.every((x) => x);
    }

    return current.pages.length > previous.pages.length;
  }

  Future<T?> onListenPage<T>(BuildContext context, PageState state) async {
    if (state.isPush) {
      final result = await Navigator.of(context).pushNamed<T>(state.current);
      _pageCubit.pop();
      return result;
    }

    return Navigator.of(context).pushReplacementNamed<T, T>(state.current);
  }
}
