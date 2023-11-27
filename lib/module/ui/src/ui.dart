import 'package:face_commute/module/module.dart';
import 'package:flutter/material.dart';

final class UI {
  static const SizedBox empty = SizedBox.shrink();
  static const Spacer spacer = Spacer();

  static const Radius radius = Radius.circular(Values.radiusValue);
  static const Radius radiusCircle = Radius.circular(Values.radiusCircleValue);

  static const BorderRadius borderRadius = BorderRadius.all(radius);
  static const BorderRadius borderRadiusCircle = BorderRadius.all(radiusCircle);
}
