import 'package:face_commute/model/model.dart';
import 'package:face_commute/ui/app/app.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    App(
      initialRoute: RouteModel.main(),
    ),
  );
}
