import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

import 'Camera.dart';
import 'pokemon.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:vibration/vibration.dart';

import 'PokemonInfo.dart';

void main() => runApp(MaterialApp(
      title: 'Pokédex',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  PokeHub hub;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
//    print('2nd work');
  }

  fetchData() async {
    var res = await http.get(url);
    var decodedJson = jsonDecode(res.body);
    print(res.body);

    hub = PokeHub.fromJson(decodedJson);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text('National Pokédex'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 3,
      ),
      body: hub == null
          ? Center(
              child: Image(image: AssetImage('assets/pokeLoading.gif')),
            )
          : GridView.count(
              crossAxisCount: 3,
              children: hub.pokemon
                  .map((poke) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PokeInfo(
                                          currentPokemon: poke,
                                        )));
                          },
                          splashColor: Colors.white,
                          child: Hero(
                              tag: poke.img,
                              child: Container(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
//                            shape: CircleBorder(),
                                  elevation: 2.0,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PokeInfo(
                                                          currentPokemon: poke,
                                                        )));
                                          },
                                          splashColor: Colors.cyan,
                                        ),
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
//                                        alignment: Alignment.topCenter,
                                                        image: NetworkImage(
                                                            poke.img)) ==
                                                    null
                                                ? DecorationImage(
                                                    image: NetworkImage(
                                                        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"))
                                                : DecorationImage(
                                                    image: NetworkImage(
                                                        poke.img))),
                                      ),
//                              Text(poke.name,style: TextStyle(fontFamily: ''))
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      ))
                  .toList(),
            ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  Text(
                    'Kanto Pokédex',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              decoration: BoxDecoration(color: Colors.redAccent),
            ),
            ListTile(
              title: Text("Recents"),
//              onTap: ,
            ),
            ListTile(
              title: Text("Favorites"),
            ),
            ListTile(
              title: Text("Camera"),
              onTap: () async {
                final cameras = await availableCameras();
                final firstCamera = cameras.first;
                if (Vibration.hasVibrator() != null) {
                  Vibration.vibrate(duration: 50);
                  print(Vibration.hasVibrator());
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SnapScreen(
                              camera: firstCamera,
                            )));
              },
            ),
            ListTile(
              title: Text("Pokedex"),
//              onTap: ,
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final cameras = await availableCameras();
          final firstCamera = cameras.first;
          if (Vibration.hasVibrator() != null) {
            Vibration.vibrate(duration: 50);
            print(Vibration.hasVibrator());
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SnapScreen(
                        camera: firstCamera,
                      )));
        },
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//      floatingActionButton:
    );
  }
}
