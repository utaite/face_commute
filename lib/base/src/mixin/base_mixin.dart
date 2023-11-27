import 'package:flutter/material.dart';

mixin BaseMixin {
  BuildContext get context;

  void pop<T>([T? result]) {
    Navigator.of(context).pop(result);
  }
}
