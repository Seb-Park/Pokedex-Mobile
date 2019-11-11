import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'PokeApiDetails.dart';
import 'pokemon.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_dex/PokeSpecies.dart';


class PokeInfo extends StatefulWidget {
  final Pokemon currentPokemon;

  PokeInfo(
      {this.currentPokemon});
  @override
  _PokeInfoState createState() => _PokeInfoState();
}

class _PokeInfoState extends State<PokeInfo> {
  Map colorTypeMap;
  Map colorAbilitiesMap;

  var theUrl;

  PokemonSpecies currentPokemonSpecies;
  PokeAPIData currentPokeApiData;

  List<String> abilities;

  String species;

  mainBody(BuildContext context) => Stack(
        children: <Widget>[
          Container(
            color: colorTypeMap[widget.currentPokemon.type[0]],
          ),

          Positioned(
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width/1,
//            left: MediaQuery.of(context).size.width,
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
                    SizedBox(height: 80),
//                    Text(
//                      currentPokemon.name,
//                      style:
//                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                    ),
                    Text(
                      "Pokedex No. " + widget.currentPokemon.num,
                      style: TextStyle(fontWeight: FontWeight.w100),
                    ),
                    currentPokemonSpecies == null ? Text("The pokemon")
                        : Text("The " + currentPokemonSpecies.genera[2].genus),
                    Text(currentPokemonSpecies.flavorTextEntries[1].flavorText, textAlign: TextAlign.center,),
                    Text("Abilities: "),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: currentPokeApiData.abilities
                          .map((t) => FilterChip(
                          backgroundColor: colorAbilitiesMap[t.isHidden],
                          label: Text(t.ability.name.toString()),
                          onSelected: (b) {}))
                          .toList(),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: widget.currentPokemon.type
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
                  tag: widget.currentPokemon.img,
                  child: Container(
                    height: 150,
                    width: 150,
                    child: Card(
                      elevation: 5,
                      shape: CircleBorder(),
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://randompokemon.com/sprites/normal/" +
                                        widget.currentPokemon.id.toString() +
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
    colorAbilitiesMap = {
      true: Colors.pink,
      false: null
    };
    var url = 'https://pokeapi.co/api/v2/pokemon/' +
        widget.currentPokemon.id.toString() +
        "/";
    var speciesUrl = 'https://pokeapi.co/api/v2/pokemon-species/' +
        widget.currentPokemon.id.toString() +
        "/";
    theUrl = speciesUrl;

    //TODO: For some reason the script isn't getting past this part because it awaits or something. Therefore it can't show the abilities.

    var res = await http.get(url);
    var speciesRes = await http.get(speciesUrl);
    var decodedJson = jsonDecode(res.body);
    var decodedSpecies = jsonDecode(speciesRes.body);
//    print(res.body);
//    print(speciesRes.body);

    currentPokemonSpecies = PokemonSpecies.fromJson(decodedSpecies);
    currentPokeApiData = PokeAPIData.fromJson(decodedJson);
    print("The " + currentPokemonSpecies.genera[2].genus.toString());

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    fetchData();
//    print("The color of this pokemon is " + currentPokemonSpecies.color.name);
//    while(species == null) {}
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorTypeMap[widget.currentPokemon.type[0]],
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          widget.currentPokemon.name,
          textAlign: TextAlign.center,
        ),
      ),
//        body: Container(
//            decoration: BoxDecoration(
//                image: DecorationImage(
//                    image: AssetImage("assets/images/bg.gif"),
//                    fit: BoxFit.cover))));
      body:
      currentPokemonSpecies == null?
      Center(
        child: CircularProgressIndicator(
          //TODO: This will go on forever unless you do a quick reload in Android Studio in which case it will show the pokemon
        ),
      ):
          mainBody(context),
    );
  }
}
