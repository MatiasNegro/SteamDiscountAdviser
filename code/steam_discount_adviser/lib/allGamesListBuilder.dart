//
// DO-NOT REMOVE THE UNUSED IMPORTS, FLUTTER SAYS WRONG
//
import 'package:flutter/material.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:provider/provider.dart';
import 'package:steam_discount_adviser/requests.dart';
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
  final textController = TextEditingController();

  ///[data] will be the list of the steam games library
  // ignore: prefer_typing_uninitialized_variables
  late var data;

  /// [dataBackup] is needed to make a searchable bar
  // ignore: prefer_typing_uninitialized_variables
  late var dataBackup;
  List results = [];
  bool flag = false;

  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    data = SteamRequest().getAllGames();
  }

  ///[_runFilter(String enteredKeyword)] is the business logic of the searchbar
  void _runFilter(String enteredKeyword) {
    if (!flag) {
      ///If is the first search, the data is saved in case all keywords were deleted
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
                                        if (gameInfo["is_free"] == false &&
                                            // ignore: unrelated_type_equality_checks
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
                                                    child: SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              width: 500,
                                                              height: 500,
                                                              padding:
                                                                  const EdgeInsets
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
                                                                    const TextStyle(
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                // ignore: prefer_interpolation_to_compose_strings
                                                                Text("Prezzo: " +
                                                                    gameInfo[
                                                                            "price_overview"]
                                                                        [
                                                                        "final_formatted"]),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                    "Sconto: ${gameInfo["price_overview"]["discount_percent"]}")
                                                              ],
                                                            ),
                                                            //Button unther row with text
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  Map item = {
                                                                    "id": id,
                                                                    "name": name
                                                                  };
                                                                  context
                                                                      .read<
                                                                          GameList>()
                                                                      .addToGameList(
                                                                          item);
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
                                                                  const EdgeInsets
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
                                                                    const TextStyle(
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ),
                                                            const Center(
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
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blueGrey,
                                  ),
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.black,
                                  )));
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
                                              child: SizedBox(
                                                  width: 300.0,
                                                  height: 300.0,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        ///[MediaQuery.of()] is being used to let the window be reactive
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
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
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          // ignore: prefer_interpolation_to_compose_strings
                                                          Text("Prezzo: " +
                                                              gameInfo[
                                                                      "price_overview"]
                                                                  [
                                                                  "final_formatted"]),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                              "Sconto: ${gameInfo["price_overview"]["discount_percent"]}"),
                                                        ],
                                                      ),
                                                      /*const SizedBox(
                                                        width: 10.0,
                                                        height: 10.0,
                                                      ),*/
                                                      Row(
                                                        children: [
                                                          const Text(
                                                              "Price below"),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    15.0,
                                                                    15.0,
                                                                    0.0,
                                                                    0.0),
                                                            child: SizedBox(
                                                                width: 50.0,
                                                                height: 10.0,
                                                                child:
                                                                    TextField(
                                                                  decoration:
                                                                      const InputDecoration(
                                                                          label:
                                                                              Text(
                                                                    "insert price",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                                  )),
                                                                  controller:
                                                                      textController,
                                                                )),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 20.0,
                                                        width: 20.0,
                                                      ),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            var selectedPrice =
                                                                textController
                                                                    .value.text;
                                                            print(
                                                                "il prezzo selezionato e': $selectedPrice");
                                                            Map item = {
                                                              "id": id,
                                                              "name": name,
                                                              "selectedPrice":
                                                                  selectedPrice
                                                            };

                                                            context
                                                                .read<
                                                                    GameList>()
                                                                .addToGameList(
                                                                    item);
                                                          },
                                                          child: const Text(
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
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: SizedBox(
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
                                                            const EdgeInsets
                                                                    .fromLTRB(
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
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                      const Center(
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
