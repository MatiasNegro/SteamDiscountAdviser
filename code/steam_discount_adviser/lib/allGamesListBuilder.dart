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
import 'package:steam_discount_adviser/dialogFactory.dart';

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
  late var myDialogF;

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
    this.myDialogF = DialogFactory();
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
              const SizedBox(height: 10),
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
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                                                return myDialogF.allGamesDialog(
                                                    id,
                                                    name,
                                                    gameInfo,
                                                    context);
                                              });
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return this
                                                    .myDialogF
                                                    .allGamesDialogFree(
                                                        id, name, context);
                                              });
                                        }
                                      },
                                    ),
                                  );
                                }),
                              );
                            } else {
                              return Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                                          return this.myDialogF.allGamesDialog(
                                              id, name, gameInfo, context);
                                        });
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return this
                                              .myDialogF
                                              .allGamesDialogFree(
                                                  id, name, context);
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
