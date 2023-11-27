import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension BoolOptionalEx on bool? {
  bool get elvis => this ?? false;
}

extension BrightnessOptionalEx on Brightness? {
  bool get isDark => this == Brightness.dark;

  Brightness get toggle => isDark ? Brightness.light : Brightness.dark;

  SystemUiOverlayStyle get statusBarStyle => isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
}

extension BuildContextEx on BuildContext {
  T singleton<T extends StateStreamableSource<Object?>>(T Function() create) {
    try {
      return read<T>();
    } on Exception {
      return create.call();
    }
  }
}

extension ColorOptionalEx on Color? {
  Color get elvis => this ?? Colors.transparent;
}

extension DateTimeEx on DateTime {
  String get dateAndTime => '$year-${'$month'.padLeft(2, '0')}-${'$day'.padLeft(2, '0')} ${'$hour'.padLeft(2, '0')}:${'$minute'.padLeft(2, '0')}';
}

extension DurationOptinoalEx on Duration? {
  Duration get elvis => this ?? Duration.zero;
}

extension IntOptionalEx on int? {
  int get elvis => this ?? 0;
}

extension IterableOptionalEx<T> on Iterable<T>? {
  Iterable<T> get elvis => this ?? const Iterable.empty();

  T? operator [](int? i) => (i?.isNotNegative).elvis && elvis.length > i.elvis ? elvis.elementAt(i.elvis) : null;
}

extension NumEx on num {
  bool get isNotNegative => !isNegative;
}

extension StringOptionalEx on String? {
  String get elvis => this ?? '';

  bool get isNullOrEmpty => this == null || (this?.isEmpty).elvis;

  bool get isset => !isNullOrEmpty;
}

extension WidgetEx on Widget {
  Widget maxWidth({double width = 360}) => Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: width),
            child: this,
          ),
        ],
      );

  Widget get sliverBox => SliverToBoxAdapter(child: this);

  Widget get sliverFill => SliverFillRemaining(hasScrollBody: false, child: this);

  Widget get red => ColoredBox(color: Colors.red, child: this);

  Widget get green => ColoredBox(color: Colors.green, child: this);

  Widget get blue => ColoredBox(color: Colors.blue, child: this);
}
