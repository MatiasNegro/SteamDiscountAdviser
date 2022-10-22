import 'dart:core';

import 'package:flutter/material.dart';
import 'package:steam_discount_adviser/notificator.dart';
import 'package:steam_discount_adviser/requests.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:steam_discount_adviser/dialogFactory.dart' as df;
import 'package:steam_discount_adviser/widgetFactory.dart';
import 'package:steam_discount_adviser/notificator.dart';

class GameList with ChangeNotifier {
  late var _data;
  bool hasChanged = false;
  late var displayedData = buildListOfGames();
  var dialogFactory = df.DialogFactory();

  ///[databaseBackup] contains the gameList at the iteration i-1
  var databaseBackup;
  bool backupFlag = true;
  get gameList => _data;
  bool firstIterationFlag = true;

  /*Future<List> takeList() async {
    List toReturn = await SteamRequest().getSelectedGames as List;
    return toReturn;
  }*/

  void changeFlag() {
    backupFlag = !backupFlag;
  }

  addToGameList(var item) async {
    String path = await getDatabasesPath();
    final Database database = await openDatabase(
      join(path, 'selectedGames.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE GAMES(ID TEXT PRIMARY KEY, NAME TEXT, DESIRED_PRICE TEXT)',
        );
      },
      version: 1,
    );

    await database.insert("GAMES", {
      "ID": item["id"],
      "NAME": item["name"],
      "DESIRED_PRICE": item["selectedPrice"]
    });
    hasChanged = true;
    displayedData = buildListOfGames();
    notifyListeners();
    changeFlag();
    hasChanged = false;
  }

  removeFromGameList(var id) async {
    String path = await getDatabasesPath();
    final Database database = await openDatabase(
      join(path, 'selectedGames.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE GAMES(ID TEXT PRIMARY KEY, NAME TEXT, DESIRED_PRICE TEXT)',
        );
      },
      version: 1,
    );

    await database.delete("GAMES", where: "ID = ?", whereArgs: [id]);
    hasChanged = true;
    displayedData = buildListOfGames();
    changeFlag();
    notifyListeners();
    hasChanged = false;
  }

  dropGameList() {
    //...
    notifyListeners();
  }

  notifyLeftBuilder() {
    hasChanged = true;
    notifyListeners();
    hasChanged = false;
  }

  Widget buildListOfGames() {
    var isLoading = true;
    return Expanded(
        //Creation of the list.
        child: FutureBuilder(
      ///Retrive of the [data] with db interrogation
      future: _data = SteamRequest().getSelectedGames(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          isLoading = false;
          _data = snapshot.data;
          if (backupFlag) {
            databaseBackup = _data;
            backupFlag = false;
          }
          return ListView.builder(
            controller: ScrollController(),
            itemCount: _data.length,
            itemBuilder: ((BuildContext context, int index) {
              //If is the first iteration, notify for all games in discount
              if (firstIterationFlag) {
                //The notifications may not start on first iteration
                //possible bug in the package
                //Solution: restart
                SteamNotificator()
                    .Notify(_data[index]["ID"], _data[index]["DESIRED_PRICE"]);
                firstIterationFlag = false;
              }

              ///If there is a game that was not in [_data] at the iteration i-1, try the notify
              if (!databaseBackup.contains(_data[index])) {
                SteamNotificator()
                    .Notify(_data[index]["ID"], _data[index]["DESIRED_PRICE"]);
              }
              return Card(
                color: Colors.blueGrey[300],
                //Tiles creation
                child: ListTile(
                  title: Text(_data[index]["NAME"]),
                  onTap: () async {
                    var id = _data[index]["ID"];
                    var name = _data[index]["NAME"];
                    // ignore: prefer_typing_uninitialized_variables
                    var price;
                    //removeFromGameList(id);
                    //Retriving the game price informations
                    await SteamRequest().getGameDetails(id).then((value) {
                      price = value["price_overview"]["final_formatted"];
                    });
                    //Pop-up dialog on tile click
                    showDialog(
                        context: context,
                        builder: (context) {
                          return this
                              .dialogFactory
                              .SelectedGamesDialog(id, name, price, context);
                        });
                  },
                ),
              );
            }),
          );
        } else {
          //If problems with the database are found, is returned a progress indicator while the app
          //"searches" a solution
          return WidgetFactory().styledCircularIndicator();
        }
      },
    ));
  }
}
