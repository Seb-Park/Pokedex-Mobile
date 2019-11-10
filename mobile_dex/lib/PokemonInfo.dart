import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'pokemon.dart';
import 'package:http/http.dart' as http;

class PokeAPIInformation {
  
}

class PokeInfo extends StatelessWidget {
  final Pokemon currentPokemon;
  Map colorTypeMap;
  var theUrl;
  PokeInfo(
      {this.currentPokemon}); //I'm pretty sure that this means that the constructor requires a pokemon

//  mainBody(BuildContext context) => Stack(
//
//
//  );

  List<String> abilities;
  String species;

  mainBody(BuildContext context) => Stack(

    children: <Widget>[
      Container(
        color: colorTypeMap[currentPokemon.type[0]],
      ),
      Positioned(

        height: MediaQuery.of(context).size.height / 1.7,
        width: MediaQuery.of(context).size.width,
        top: MediaQuery.of(context).size.height / 15,
//            decoration: BoxDecoration(
//                image: DecorationImage(
//                    image: AssetImage("assets/images/bg.gif"),
//                    fit: BoxFit.cover)),
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            elevation: 2.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(height: 30),
//                    Text(
//                      currentPokemon.name,
//                      style:
//                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                    ),
                Text(
                  "Pokedex No. " + currentPokemon.num,
                  style: TextStyle(fontWeight: FontWeight.w100),
                ),
                Text("The $species"),
                Text("Abilities" + abilities.toString() +theUrl),



                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: currentPokemon.type
                      .map((t) => FilterChip(
                      backgroundColor: colorTypeMap[t],
                      label: Text(t),
                      onSelected: (b) {}))
                      .toList(),
                ),
              ],
            )),
      ),
      Align(
          alignment: Alignment.topCenter,
          child: Hero(
              tag: currentPokemon.img,
              child: Container(
                height: 150,
                width: 150,
                child: Card(
                  shape: CircleBorder(),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://randompokemon.com/sprites/normal/" +
                                    currentPokemon.id.toString() +
                                    ".gif"))),
                  ),
                ),
              )))
    ],
  );

  fetchData() async {
    colorTypeMap = {
      'Water': Colors.blue,
      'Grass': Colors.greenAccent,
      'Fire': Colors.deepOrange,
      'Normal': Colors.grey,
      'Electric': Colors.yellow,
      'Fighting': Colors.red,
      'Rock': Colors.amber,
      'Ground': Colors.amber,
      'Flying': Colors.cyan,
      'Bug': Colors.amber,
      'Poison': Colors.purpleAccent,
      'Dark': Colors.brown,
      'Ghost': Colors.deepPurple,
      'Ice': Colors.cyanAccent,
      'Steel': Colors.grey,
      'Psychic': Colors.pinkAccent,
      'Dragon': Colors.purple,
      'Fairy': Colors.pink
    };
    var url = 'https://pokeapi.co/api/v2/pokemon/' +
        currentPokemon.id.toString() +
        "/";
    var speciesUrl = 'https://pokeapi.co/api/v2/pokemon-species/' +
        currentPokemon.id.toString() +
        "/";
    theUrl = speciesUrl;

    //TODO: For some reason the script isn't getting past this part because it awaits or something. Therefore it can't show the abilities.

    var res = await http.get(url);
    var speciesRes = await http.get(speciesUrl);
    var decodedJson = jsonDecode(res.body);
    var decodedSpecies = jsonDecode(speciesRes.body);
    print(res.body);
    print(speciesRes.body);

//    theUrl = decodedJson;
//
//    abilities = new List.from(decodedJson['abilities']);
//    print("!!!ABILITIES: " + abilities[0]);
//    species = (new Map<String, dynamic>.from(
//        (new List.from(decodedSpecies['genera']))[2]))['genus'];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    fetchData();
//    while(species == null) {}
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorTypeMap[currentPokemon.type[0]],
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          currentPokemon.name,
          textAlign: TextAlign.center,
        ),
      ),
//        body: Container(
//            decoration: BoxDecoration(
//                image: DecorationImage(
//                    image: AssetImage("assets/images/bg.gif"),
//                    fit: BoxFit.cover))));
      body:
      species == null?
      Center(
        child: CircularProgressIndicator(

        ),
      ):
      mainBody(context),
    );

  }
}
