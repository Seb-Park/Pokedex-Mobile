import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SnapScreen extends StatefulWidget {
  final CameraDescription camera;

  const SnapScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<SnapScreen> {
  CameraController cameraController;
  Future<void> initCamController;

  @override
  void initState() {
    super.initState();

    cameraController = CameraController(widget.camera, ResolutionPreset.high);
    initCamController = cameraController.initialize();
  }

  @override
  void dispose() {
    //When we get rid of the controller get rid of these widgets
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar:
      AppBar(
        backgroundColor: Colors.red,

      ),
      body: FutureBuilder<void>(
        future: initCamController,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(cameraController);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera),
          onPressed: () async {
            try {
              await initCamController;
              final path = join(
                (await getTemporaryDirectory()).path,
                '${DateTime.now()}.png',
              );
              await cameraController.takePicture(path);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(imagePath: path),
                ),
              );
            } catch (exception) {}
          },
          backgroundColor: Colors.grey),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Photo', style: TextStyle(color: Colors.black),

        ),
        iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
        elevation: 0,

    ),
    // The image is stored as a file on the device. Use the `Image.file`
    // constructor with the given path to display the image.
    body:
    Container(
    child: Align(
    child: Image.file(File(imagePath)),
    alignment: Alignment.center,
    )
    )
    );
  }
}
