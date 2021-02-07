import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:camera/camera.dart';

class CameraBloc {
  final _imagePathController = BehaviorSubject<String>();
  CameraDescription camera;
  CameraController _cameraController;

  Stream<String> readImagePath() => _imagePathController.stream;

  CameraBloc() {
    this._cameraController =
        CameraController(this.camera, ResolutionPreset.medium);
    this._cameraController.initialize();
  }

  CameraController getCameraController() => this._cameraController;
  bool isCameraControllerReady() => this._cameraController.value.isInitialized;

  void setupCamera() async {
    final cameras = await availableCameras();
    this.camera = cameras.first;
  }

  void obtainImage() async {
    XFile xPlatformFile = await _cameraController.takePicture();
    _imagePathController.sink.add(xPlatformFile.path);
  }

  void dispose() {
    _imagePathController.close();
    _cameraController.dispose();
  }
}
