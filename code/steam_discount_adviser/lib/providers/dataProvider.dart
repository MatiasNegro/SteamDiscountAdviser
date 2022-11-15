import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:steam_discount_adviser/notificator.dart';
import 'package:steam_discount_adviser/requests.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:steam_discount_adviser/dialogFactory.dart' as df;
import 'package:steam_discount_adviser/widgetFactory.dart';
import 'package:steam_discount_adviser/notificator.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class GameList with ChangeNotifier {
  int counter = 0;
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
    ///[path] gets the flutter-standard database path
    String path = await getDatabasesPath();

    if (Platform.isWindows || Platform.isLinux) {
      var databaseFactory = databaseFactoryFfi;
      var db =
          await databaseFactory.openDatabase(join(path, 'selectedGames.db'));
      await db.execute('''
              CREATE TABLE GAMES(ID TEXT PRIMARY KEY, NAME TEXT, DESIRED_PRICE TEXT)
              ''');

      await db.insert("GAMES", {
        "ID": item["id"],
        "NAME": item["name"],
        "DESIRED_PRICE": (item["selectedPrice"] as String).contains(",")
            ? (item["selectedPrice"] as String).replaceAll(",", ".")
            : (item["selectedPrice"])
      });
    } else {
      //Opening the database (if the onCreate is necesasry)
      final Database database = await openDatabase(
        join(path, 'selectedGames.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE GAMES(ID TEXT PRIMARY KEY, NAME TEXT, DESIRED_PRICE TEXT)',
          );
        },
        version: 1,
      );

      ///[database.insert()] instert the chosen game into the database
      await database.insert("GAMES", {
        "ID": item["id"],
        "NAME": item["name"],
        "DESIRED_PRICE": item["selectedPrice"]
      });
      database.close();
    }
    hasChanged = true;

    displayedData = buildListOfGames();
    notifyListeners();
    changeFlag();
    hasChanged = false;
  }

  removeFromGameList(var id) async {
    String path = await getDatabasesPath();
    if (Platform.isWindows || Platform.isLinux) {
      var databaseFactory = databaseFactoryFfi;
      var db =
          await databaseFactory.openDatabase(join(path, 'selectedGames.db'));
      await db.execute('''
              CREATE TABLE GAMES(ID TEXT PRIMARY KEY, NAME TEXT, DESIRED_PRICE TEXT)
              ''');
      await db.delete("GAMES", where: "ID = ?", whereArgs: [id]);

      db.close();
    } else {
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
      database.close();
    }

    hasChanged = true;

    displayedData = buildListOfGames();
    changeFlag();
    notifyListeners();
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

          counter++;
          int counter_1 = 0;
          if (backupFlag) {
            databaseBackup = _data;
            backupFlag = false;
          }
          return ListView.builder(
            controller: ScrollController(),
            itemCount: _data.length,
            itemBuilder: ((BuildContext context, int index) {
              //If is the first iteration, notify for all games in discount
              if (firstIterationFlag && counter_1 != _data.length + 1) {
                //The notifications may not start on first iteration
                //possible bug in the package
                //Solution: restart

                SteamNotificator()
                    .Notify(_data[index]["ID"], _data[index]["DESIRED_PRICE"]);
                counter_1++;
                if (counter_1 == _data.length - 1) {
                  firstIterationFlag = false;
                }
                //firstIterationFlag = false;
              }

              ///If there is a game that was not in [_data] at the iteration i-1, try the notify

              ///[databasebackuo.contains()] checks for object isntance
              ///So i forced to check the Id's with another [List] type variable [databaseIds]
              List databaseIds = [];
              (databaseBackup as List).forEach((element) {
                databaseIds.add(element["ID"]);
              });
              if (!databaseIds.contains(_data[index]["ID"]) &&
                  !firstIterationFlag &&
                  counter % 2 != 0) {
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
                    var selectedPrice;
                    //removeFromGameList(id);
                    //Retriving the game price informations
                    await SteamRequest().getGameDetails(id).then((value) {
                      price = value["price_overview"]["final_formatted"];
                    });
                    await SteamRequest().getSelectedPrice(id).then((value) {
                      selectedPrice = value;
                    });

                    //Pop-up dialog on tile click
                    showDialog(
                        context: context,
                        builder: (context) {
                          return this.dialogFactory.SelectedGamesDialog(
                              id, name, price, selectedPrice, context);
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
