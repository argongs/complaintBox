import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../db/database_interface.dart';
import '../db/database_provider.dart';

class CameraScreen extends StatefulWidget {
  final DatabaseInterface dbInterface;
  final CameraDescription camera;

  const CameraScreen(
      {Key key, @required this.dbInterface, @required this.camera})
      : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _cameraController;
  Future<void> _intialiseCameraControllerFuture;

  @override
  void initState() {
    super.initState();

    this._cameraController =
        CameraController(widget.camera, ResolutionPreset.medium);

    this._intialiseCameraControllerFuture = this._cameraController.initialize();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: FutureBuilder<void>(
          future: _intialiseCameraControllerFuture,
          builder: (BuildContext context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.done) {
              return CameraPreview(this._cameraController);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Click image!",
          child: Icon(Icons.camera_alt),
          onPressed: () async {
            try {
              await _intialiseCameraControllerFuture;
              XFile xPlatformFile = await _cameraController.takePicture();
              print(xPlatformFile ?? "Path not availible");
              widget.dbInterface.setPathToCameraImage(xPlatformFile.path);
            } catch (e) {
              print(e);
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  @override
  void dispose() {
    this._cameraController.dispose();
    super.dispose();
  }
}
