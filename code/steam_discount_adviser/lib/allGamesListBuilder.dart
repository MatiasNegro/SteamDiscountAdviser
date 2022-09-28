import 'dart:convert';
import 'dart:io';
import 'package:io/io.dart';
import 'package:flutter/material.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:steam_discount_adviser/Game.dart';
import 'package:steam_discount_adviser/requests.dart';
import 'package:steam_discount_adviser/gameListWidgetBuilder.dart' as games;
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:steam_discount_adviser/providers/dataProvider.dart';

class TileList extends StatefulWidget {
  TileList({Key? key}) : super(key: key);

  @override
  State<TileList> createState() => _TileListState();
}

class _TileListState extends State<TileList> {
  late var data;
  late var names;
  late var dataBackup;
  List results = [];
  bool flag = false;

  @override
  void initState() {
    super.initState();
    data = SteamRequest().getAllGames();
  }

  void _runFilter(String enteredKeyword) {
    if (!flag) {
      dataBackup = List.from(data);
    }
    results = List.from(dataBackup);
    if (data != []) {
      results = List.from(dataBackup);
      if (enteredKeyword.isEmpty) {
        results = List.from(dataBackup);
      } else {
        results.removeWhere((element) => !(element["name"] as String)
            .toLowerCase()
            .contains(enteredKeyword));
        // we use the toLowerCase() method to make it case-insensitive
      }

      // Refresh the UI
      flag = true;
      setState(() {
        data = List.from(results);
      });
    }
  }

  void addGameToList(id, name) async {
    String path = await getDatabasesPath();
    final Database database = await openDatabase(
      join(path, 'selectedGames.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE GAMES(ID TEXT PRIMARY KEY, NAME TEXT)',
        );
      },
      version: 1,
    );
    await database.insert("GAMES", {"ID": id, "NAME": name});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  onChanged: (value) {
                    _runFilter(value);
                  },
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "Search game",
                    filled: true,
                    fillColor: Colors.grey[400],
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                  child: !flag
                      ? FutureBuilder(
                          future: data,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              data = snapshot.data;
                              return ListView.builder(
                                controller: ScrollController(),
                                itemCount: data.length == 0 ? 0 : data.length,
                                itemBuilder:
                                    ((BuildContext context, int index) {
                                  return Card(
                                    color: Colors.blueGrey[300],
                                    child: ListTile(
                                      title: Text(data[index]["name"]),
                                      onTap: () async {
                                        var id = data[index]["appid"];
                                        var name = data[index]["name"];
                                        var gameInfo = await SteamRequest()
                                            .getGameDetails(id);
                                        if (gameInfo["steam_appid"] == 80924) {
                                          print(gameInfo);
                                        }
                                        if (gameInfo["is_free"] == false &&
                                            (gameInfo["type"] == "game" ||
                                                    gameInfo["type"]) ==
                                                "dlc") {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                    backgroundColor:
                                                        Colors.blueGrey[100],
                                                    elevation: 8.0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Container(
                                                        width: 100.0,
                                                        height: 100.0,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          10,
                                                                          10,
                                                                          10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                        .blueGrey[
                                                                    200],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Text(
                                                                name,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text("Prezzo: " +
                                                                    gameInfo[
                                                                            "price_overview"]
                                                                        [
                                                                        "final_formatted"]),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text("Sconto: " +
                                                                    gameInfo["price_overview"]
                                                                            [
                                                                            "discount_percent"]
                                                                        .toString())
                                                              ],
                                                            ),
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  addGameToList(
                                                                      id, name);
                                                                },
                                                                child: Text(
                                                                    "Add game to list"))
                                                          ],
                                                        )));
                                              });
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                    backgroundColor:
                                                        Colors.blueGrey[100],
                                                    elevation: 8.0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Container(
                                                        width: 100.0,
                                                        height: 100.0,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          10,
                                                                          10,
                                                                          10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                        .blueGrey[
                                                                    200],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Text(
                                                                name,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ),
                                                            Center(
                                                              child: Text(
                                                                  "this game is free!"),
                                                            )
                                                          ],
                                                        )));
                                              });
                                        }
                                      },
                                    ),
                                  );
                                }),
                              );
                            } else {
                              return Container(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.black,
                                  )),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blueGrey,
                                  ));
                            }
                          },
                        )
                      : ListView.builder(
                          controller: ScrollController(),
                          itemCount: (data as List).length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.blueGrey[300],
                              child: ListTile(
                                title: Text(data[index]["name"]),
                                onTap: () async {
                                  var id = data[index]["appid"];
                                  var name = data[index]["name"];
                                  var gameInfo =
                                      await SteamRequest().getGameDetails(id);
                                  if (gameInfo["is_free"] == false &&
                                      (gameInfo["type"] == "game" ||
                                          gameInfo["type"] == "dlc")) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                              backgroundColor:
                                                  Colors.blueGrey[100],
                                              elevation: 8.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Container(
                                                  width: 100.0,
                                                  height: 100.0,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                10, 10, 10, 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .blueGrey[200],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Text(
                                                          name,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text("Prezzo: " +
                                                              gameInfo[
                                                                      "price_overview"]
                                                                  [
                                                                  "final_formatted"]),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text("Sconto: " +
                                                              gameInfo["price_overview"]
                                                                      [
                                                                      "discount_percent"]
                                                                  .toString()),
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                addGameToList(
                                                                    id, name);
                                                              },
                                                              child: Text(
                                                                  "Add game to list"))
                                                        ],
                                                      ),
                                                    ],
                                                  )));
                                        });
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          print("false");
                                          return Dialog(
                                              backgroundColor:
                                                  Colors.blueGrey[100],
                                              elevation: 8.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Container(
                                                  width: 100.0,
                                                  height: 100.0,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                10, 10, 10, 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .blueGrey[200],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Text(
                                                          name,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Text(
                                                            "this game is free!"),
                                                      )
                                                    ],
                                                  )));
                                        });
                                  }
                                },
                              ),
                            );
                          }))
            ]),
      ),
    );
  }
}
