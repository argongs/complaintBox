import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameras = await availableCameras();
  runApp(App(cameras));
}
