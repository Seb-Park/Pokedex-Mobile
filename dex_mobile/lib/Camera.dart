import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloudinary_client/models/CloudinaryResponse.dart';
import 'PokemonInfo.dart';
import 'pokemon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:cloudinary_client/cloudinary_client.dart';

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

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  DisplayPictureScreen({this.imagePath});

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  var urlImagePath;
  var poke1name;

//  final String imageName;

//  static File imageFile = new File(imagePath);
//  static List<int> imageBytes = imageFile.readAsBytesSync();
//  final String base64Image = base64.encode(imageBytes);

//  DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  void uploadToCloudinary(/*BuildContext context*/) async {
    print("performing upload to cloudinary");
    CloudinaryClient client = new CloudinaryClient(
        "789664171312918", "Z-evOmUdPc5RhOwsBU53lmthzhQ", "dhd22tnja");
    CloudinaryResponse response = (await client.uploadImage(widget.imagePath));
//    print(response.toJson()['url']);
    urlImagePath = response.toJson()['url'];
    var res = await http.get("http://192.168.7.57:3008/?img=" + urlImagePath);
    var decodedJson = jsonDecode(res.body);
    poke1name = (((decodedJson['possible_pokemon'])[0])['name']).toString();
//    poke1name = decodedJson.toString();
    print(poke1name);
    print(urlImagePath);
    setState(() {});
//    inputToHub(poke1name, context);
  }

  void inputToHub(String pName, BuildContext context) async {
    var res = await http.get(
        "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json"
    );
    var decodedJson = jsonDecode(res.body);
    print(res.body);

    PokeHub hub = PokeHub.fromJson(decodedJson);
    for (int i = 0; i < hub.pokemon.length; i++) {
      if (hub.pokemon[i].name.toLowerCase() == pName){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PokeInfo(
                      currentPokemon: hub.pokemon[i],
                    )));
        return;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uploadToCloudinary();
  }

  String encodeImg() {
    File imageFile = new File(widget.imagePath);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64.encode(imageBytes);
//    printWrapped("{" + base64Image + "} Not shortened");
    return base64Image.length.toString();
  }

  @override
  Widget build(BuildContext context) {
//    String encodedImg = encodeImg();
//    uploadToCloudinary();
//    uploadToCloudinary(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title:
          poke1name != null ? Text(
            poke1name,
            style: TextStyle(color: Colors.greenAccent),
          ) :
          Text(
            "Loading...",
            style: TextStyle(color: Colors.black),
          )
          ,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0,
        ),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Container(
            child: Align(
              child: Image.file(File(widget.imagePath)),
//          child: Text(encodedImg),
              alignment: Alignment.center,
            )),
      floatingActionButton:poke1name==null?
      FloatingActionButton(
        backgroundColor: Colors.grey,
      ):
      FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () async {
          inputToHub(poke1name, context);
        },
      )
      ,
    );
  }
}
