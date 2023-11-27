import 'package:face_commute/base/base.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract base class BaseController<B extends StateStreamable<S>, S extends BaseState> with BaseMixin {
  B get bloc => context.read();

  S get state => bloc.state;

  bool listenWhenGet(S previous, S current) => !previous.isGet && current.isGet;
}
