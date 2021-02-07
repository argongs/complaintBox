import 'package:flutter/material.dart';
import 'camera_bloc.dart';

class CameraProvider extends InheritedWidget {
  CameraProvider({Key key, Widget child}) : super(key: key, child: child);

  final cameraBloc = CameraBloc();

  bool updateShouldNotify(_) => true;

  static CameraBloc of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<CameraProvider>()).cameraBloc;
}
