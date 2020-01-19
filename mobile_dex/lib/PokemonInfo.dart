import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'PokeApiDetails.dart';
import 'pokemon.dart';
import 'package:http/http.dart' as http;
import 'PokeSpecies.dart';
import 'package:vibration/vibration.dart';

class PokeInfo extends StatefulWidget {
  final Pokemon currentPokemon;

  PokeInfo({this.currentPokemon});

  @override
  _PokeInfoState createState() => _PokeInfoState();
}

class _PokeInfoState extends State<PokeInfo> {
  Map colorTypeMap;
  Map colorAbilitiesMap;

  ScrollController _scrollController = new ScrollController();

  var theUrl;

//  var _attack = 0.1;
  var favorite = false;

  PokemonSpecies currentPokemonSpecies;
  PokeAPIData currentPokeApiData;

  List<String> abilities;

  String species;

  mainBody(BuildContext context) => Stack(
        children: <Widget>[
          Container(
//            color: colorTypeMap[widget.currentPokemon.type[0]],
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  colorTypeMap[widget.currentPokemon.type[0]][700],
                  colorTypeMap[widget.currentPokemon.type[0]][100]
                ])),
          ),
          Positioned(
//        height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width / 1,
//            left: MediaQuery.of(context).size.width,
            top: MediaQuery.of(context).size.height / 15,

            bottom: 0,

//            decoration: BoxDecoration(
//                image: DecorationImage(
//                    image: AssetImage("assets/images/bg.gif"),
//                    fit: BoxFit.cover)),
            child: new NotificationListener(
//              onNotification: (t) {
//                if (t is ScrollEndNotification) {
//                  print(_scrollController.position.pixels);
//                }
//              },
              //TODO: Implement the scroll listening: https://stackoverflow.com/questions/54065354/how-to-detect-scroll-position-of-listview-in-flutter
              child: new GridView.count(
                controller: _scrollController,
                crossAxisCount: 1,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 0.0),
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 4.0,
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
                              "Pokédex No. " + widget.currentPokemon.num,
                              style: TextStyle(fontWeight: FontWeight.w100),
                            ),
                            currentPokemonSpecies == null
                                ? Text("The pokemon")
                                : Text("The " +
                                    currentPokemonSpecies.genera[2].genus),
                            currentPokemonSpecies
                                        .flavorTextEntries[1].language.name ==
                                    'en'
                                ? Text(
                                    currentPokemonSpecies
                                        .flavorTextEntries[1].flavorText
                                        .replaceAll("\n", " "),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    currentPokemonSpecies
                                        .flavorTextEntries[2].flavorText
                                        .replaceAll("\n", " "),
                                    textAlign: TextAlign.center,
                                  ),
                            Text("Abilities: "),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: currentPokeApiData.abilities
                                  .map((t) => FilterChip(
                                      backgroundColor:
                                          colorAbilitiesMap[t.isHidden],
                                      label: Text(
                                        t.ability.name.toString().toUpperCase(),
                                        style: new TextStyle(
                                            fontWeight: FontWeight.w300),
                                      ),
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
//              SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 70.0, left: 8.0, right: 8.0, bottom: 4.0),
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 4.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
//                    SizedBox(height:30),
                            Text(
                              "Base Stats",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(
                              currentPokeApiData.totalBaseStat.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text("Attack"),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(currentPokeApiData.stats[4].baseStat
                                    .toString()),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    width: 190,
                                    height: 10,
                                    child: LinearProgressIndicator(
//                                  valueColor: Colors.blue,
                                      value:
                                          currentPokeApiData.stats[4].baseStat /
                                              200,
                                      valueColor: const AlwaysStoppedAnimation(
                                          Colors.redAccent),
                                      backgroundColor:
                                          (Colors.red).withOpacity(0.1),
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text("Defense"),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(currentPokeApiData.stats[3].baseStat
                                    .toString()),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    width: 190,
                                    height: 10,
                                    child: LinearProgressIndicator(
                                      value:
                                          currentPokeApiData.stats[3].baseStat /
                                              200,
                                      valueColor: const AlwaysStoppedAnimation(
                                          Colors.blue),
                                      backgroundColor:
                                          (Colors.blue).withOpacity(0.1),
//                                  backgroundColor: Colors.transparent,
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text("Sp. Attack"),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(currentPokeApiData.stats[2].baseStat
                                    .toString()),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    width: 190,
                                    height: 10,
                                    child: LinearProgressIndicator(
                                      value:
                                          currentPokeApiData.stats[2].baseStat /
                                              200,
                                      valueColor: const AlwaysStoppedAnimation(
                                          Colors.pinkAccent),
                                      backgroundColor:
                                          (Colors.pink).withOpacity(0.1),
//                                  backgroundColor: Colors.transparent,
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text("Sp. Defense"),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(currentPokeApiData.stats[1].baseStat
                                    .toString()),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    width: 190,
                                    height: 10,
                                    child: LinearProgressIndicator(
                                      value:
                                          currentPokeApiData.stats[1].baseStat /
                                              200,
                                      valueColor: const AlwaysStoppedAnimation(
                                          Colors.cyanAccent),
                                      backgroundColor:
                                          (Colors.cyan).withOpacity(0.1),
//                                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
//                                  backgroundColor: Colors.transparent,
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text("Speed"),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(currentPokeApiData.stats[0].baseStat
                                    .toString()),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    width: 190,
                                    height: 10,
                                    child: LinearProgressIndicator(
                                      value:
                                          currentPokeApiData.stats[0].baseStat /
                                              200,
                                      valueColor: const AlwaysStoppedAnimation(
                                          Colors.greenAccent),
                                      backgroundColor:
                                          (Colors.green).withOpacity(0.1),
//                                  backgroundColor: Colors.transparent,
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 4.0,
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Weaknesses",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          widget.currentPokemon.weaknesses.length < 5
                              ? Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: widget.currentPokemon.weaknesses
                                        .map((t) => FilterChip(
                                            backgroundColor: colorTypeMap[t],
                                            label: Text(t),
                                            onSelected: (b) {}))
                                        .toList(),
                                  ),
                                )
                              : Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: (widget
                                              .currentPokemon.weaknesses
                                              .sublist(0, 3))
                                          .map((t) => FilterChip(
                                              backgroundColor: colorTypeMap[t],
                                              label: Text(t),
                                              onSelected: (b) {}))
                                          .toList(),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: (widget
                                          .currentPokemon.weaknesses
                                          .sublist(3)
                                          .map((t) => FilterChip(
                                              backgroundColor: colorTypeMap[t],
                                              label: Text(t),
                                              onSelected: (b) {}))
                                          .toList()),
                                    )
                                  ],
                                ),
//                          GridView.count(
//                              crossAxisCount: 1,
//                            scrollDirection: Axis.horizontal,
//                            children: <Widget>[
//                              Card(
//                                elevation: 3,
//                              ),
//                              Card(
//                                elevation: 3,
//                              ),
//                              Card(
//                                elevation: 3,
//                              ),
//                            ],
//                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 4.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            "Breeding",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          currentPokemonSpecies.genderRate > -1
                              ? Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 10,
                                        value:
                                            currentPokemonSpecies.genderRate /
                                                8,
                                        backgroundColor: Colors.blue,
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                                Colors.red),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          "♂ " +
                                              (100 -
                                                      (currentPokemonSpecies
                                                                  .genderRate /
                                                              8) *
                                                          100)
                                                  .toString() +
                                              "%",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        Text(
                                          "♀ " +
                                              ((currentPokemonSpecies
                                                              .genderRate /
                                                          8) *
                                                      100)
                                                  .toString() +
                                              "%",
                                          style: TextStyle(color: Colors.red),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 10,
                                    value: 0,
                                    backgroundColor: Colors.grey,
                                    valueColor: const AlwaysStoppedAnimation(
                                        Colors.grey),
                                  ),
                                ),
                          Text("Egg Groups"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: currentPokemonSpecies.eggGroups
                                .map((t) => FilterChip(
                                    backgroundColor: Colors.grey,
                                    label: Text(t.name[0].toUpperCase() +
                                        t.name.substring(1)),
                                    onSelected: (b) {}))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
//            color: colorTypeMap[widget.currentPokemon.type[0]],
              height: 100,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
//                      begin: Alignment(0,0.2),
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    colorTypeMap[widget.currentPokemon.type[0]][700]
                        .withOpacity(0.5),
                    colorTypeMap[widget.currentPokemon.type[0]]
                        .withOpacity(0.0),
                  ])),
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Hero(
                  tag: widget.currentPokemon.img,
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Card(
                      elevation: 5,
                      shape: CircleBorder(),
                      child: Container(
                        width: 1000,
                        height: 1000,
                        decoration: BoxDecoration(
                            image: DecorationImage(
//                              fit: BoxFit.contain,
                                image: NetworkImage(
                                    "https://randompokemon.com/sprites/normal/" +
                                        widget.currentPokemon.id.toString() +
                                        ".gif"))),
                      ),
                    ),
                  ))),
          currentPokemonSpecies.evolvesFromSpecies != null
              ? Positioned(
                  top: 20.0,
                  left: -2.0,
//                child: Align(
//                    alignment: Alignment.topLeft,
                  child: Container(
                      height: 60,
                      width: 60,
                      child: Card(
                        elevation: 5,
                        shape: CircleBorder(),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://randompokemon.com/sprites/normal/" +
//                                          (int.fromEnvironment(((currentPokemonSpecies.evolvesFromSpecies.url).split("/"))[6]))
//                                              .toString()+
                                          (((currentPokemonSpecies
                                                  .evolvesFromSpecies.url)
                                              .split("/"))[6]) +
                                          ".gif"))),
                        ),
                      ))
//                ),
                  )
              : Container(),
          widget.currentPokemon.nextEvolution != null
              ? Positioned(
                  top: 20.0,
                  right: -2.0,
//                child: Align(
//                    alignment: Alignment.bottomRight,
                  child: Container(
                      height: 60,
                      width: 60,
                      child: Card(
                        elevation: 5,
                        shape: CircleBorder(),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://randompokemon.com/sprites/normal/" +
                                          (widget.currentPokemon.id + 1)
                                              .toString() +
                                          ".gif"))),
                        ),
                      ))
//                ),
                  )
              : Container(),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Align(
                  alignment: Alignment(0, 0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.white,
                      ),
//                      Text("Swipe up for more",
//                          style: TextStyle(color: Colors.white)),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                height: 120,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment(0, 0),
//                        begin: Alignment.topCenter,
                        end: Alignment(0, 0.8),
                        colors: [
                      colorTypeMap[widget.currentPokemon.type[0]][700]
                          .withOpacity(0.0),
                      colorTypeMap[widget.currentPokemon.type[0]][700]
                          .withOpacity(1.0),
                    ])),
              )),
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
    colorAbilitiesMap = {true: Colors.pink, false: null};
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

  rebuildFrame() async {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    fetchData();
//  rebuildFrame();
//    print("The color of this pokemon is " + currentPokemonSpecies.color.name);
//    while(species == null) {}
    return Scaffold(
      appBar: currentPokemonSpecies == null
          ? AppBar(
              backgroundColor: colorTypeMap[widget.currentPokemon.type[0]][700],
            )
          : AppBar(
              backgroundColor: colorTypeMap[widget.currentPokemon.type[0]][700],
              centerTitle: true,
              elevation: 0.0,
              title: Text(
                currentPokemonSpecies.names[2].name,
                textAlign: TextAlign.center,
              ),
            ),
//        body: Container(
//            decoration: BoxDecoration(
//                image: DecorationImage(
//                    image: AssetImage("assets/images/bg.gif"),
//                    fit: BoxFit.cover))));
      body: currentPokemonSpecies == null
          ? Center(
              child: Image(image: AssetImage('assets/pokeLoading.gif')),
//              child: CircularProgressIndicator(),
            )
          : mainBody(context),
      floatingActionButton: FloatingActionButton(
        child: !favorite
            ? Icon(
                Icons.favorite_border,
                color: Colors.white,
              )
            : Icon(
                Icons.favorite,
                color: Colors.white,
              ),
        onPressed: () async {
          favorite = !favorite;
          print('pressed! Favorite is ' + favorite.toString());
          if (Vibration.hasVibrator() != null) {
            Vibration.vibrate(duration: 30);
            print(Vibration.hasVibrator());
          }
          setState(() {});
        },
        backgroundColor: Colors.pink,
        tooltip: "Favorite",
      ),
    );
  }
}
