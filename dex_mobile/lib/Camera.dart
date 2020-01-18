import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

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
      appBar: AppBar(
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
//              "mostRecentCapture.png",
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
  /*static*/ final String imagePath;

//  static File imageFile = new File(imagePath);
//  static List<int> imageBytes = imageFile.readAsBytesSync();
//  final String base64Image = base64.encode(imageBytes);

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  String encodeImg() {
    File imageFile = new File(this.imagePath);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64.encode(imageBytes);
//    printWrapped("{" + base64Image + "} Not shortened");
    return base64Image.length.toString();
  }

  @override
  Widget build(BuildContext context) {
    String encodedImg = encodeImg();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Photo',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0,
        ),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Container(
            child: Align(
//              child: Image.file(File(imagePath)),
          child: Text(encodedImg),
          alignment: Alignment.center,
        )));
  }
}
