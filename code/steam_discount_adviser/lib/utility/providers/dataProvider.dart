import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:steam_discount_adviser/utility/notificator.dart';
import 'package:steam_discount_adviser/utility/requests.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:steam_discount_adviser/utility/dialogFactory.dart' as df;
import 'package:steam_discount_adviser/utility/widgetFactory.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

///Left column widget that represent the selected games from the steam list in the down section.
class GameList with ChangeNotifier {
  int counter = 0;
  late var _data;
  bool hasChanged = false;
  late var displayedData = buildListOfGames();
  var dialogFactory = df.DialogFactory();

  ///Contains the gameList at the iteration i-1
  late List databaseBackup;
  bool backupFlag = true;
  get gameList => _data;
  bool firstIterationFlag = true;
  final Connectivity _connectivity = Connectivity();

  ///Change flag to notify the listeners
  void changeFlag() {
    backupFlag = !backupFlag;
  }

  ///Function called when a right column item (game) needs to be inserted into the selected games list.
  addToGameList(var item) async {
    ///[path] gets the flutter-standard database path

    late String path;
    if (Platform.isMacOS) {
      path = await getDatabasesPath();
    }

    //Windows and Linux db initialization
    sqfliteFfiInit();

    //If the application is running on Windows or Linux use sqflite_common_ffi package
    if (Platform.isWindows || Platform.isLinux) {
      var databaseFactory = databaseFactoryFfi;
      var db = await databaseFactory.openDatabase(inMemoryDatabasePath);

      //If the db is not open at this point that means it does not exist
      if (!db.isOpen) {
        await db.execute('''
              CREATE TABLE GAMES(ID TEXT PRIMARY KEY, NAME TEXT, DESIRED_PRICE TEXT)
              ''');
      }

      await db.insert("GAMES", {
        "ID": item["id"],
        "NAME": item["name"],
        "DESIRED_PRICE": (item["selectedPrice"] as String).contains(",")
            ? (item["selectedPrice"] as String).replaceAll(",", ".")
            : (item["selectedPrice"])
      });
    } else {
      ///Else (MacOS case scenario) use the sqflite package
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

      //instert the chosen game into the database
      await database.insert("GAMES", {
        "ID": item["id"],
        "NAME": item["name"],
        "DESIRED_PRICE": item["selectedPrice"]
      });
      database.close();
    }
    hasChanged = true;
    //Refresh the left column rebuilding and redrawing it
    displayedData = buildListOfGames();
    //Notify the listeners
    notifyListeners();
    changeFlag();
    hasChanged = false;
  }

  ///Remove a game from the selected games list onClick() of the corresponding button from the Dialog
  removeFromGameList(var id) async {
    String path = await getDatabasesPath();
    if (Platform.isWindows || Platform.isLinux) {
      var databaseFactory = databaseFactoryFfi;
      var db = await databaseFactory.openDatabase(inMemoryDatabasePath);

      if (!db.isOpen) {
        await db.execute('''
              CREATE TABLE GAMES(ID TEXT PRIMARY KEY, NAME TEXT, DESIRED_PRICE TEXT)
              ''');
      }

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

  ///Left column main widget containing, showing and giving functionality to the selected games.
  Widget buildListOfGames() {
    return Expanded(
        //Creation of the list.
        child: FutureBuilder(
      ///Retrive of the [data] with db interrogation
      future: _data = SteamRequest().getSelectedGames(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                    .notify(_data[index]["ID"], _data[index]["DESIRED_PRICE"]);
                counter_1++;
                if (counter_1 == _data.length - 1) {
                  firstIterationFlag = false;
                }
              }

              //If there is a game that was not in [_data] at the iteration i-1, try the notify

              //[databasebackuo.contains()] checks for object isntance
              //So i forced to check the Id's with another [List] type variable [databaseIds]
              List databaseIds = [];
              databaseBackup.forEach((element) {
                databaseIds.add(element["ID"]);
              });
              if (!databaseIds.contains(_data[index]["ID"]) &&
                  !firstIterationFlag &&
                  counter % 2 != 0) {
                SteamNotificator()
                    .notify(_data[index]["ID"], _data[index]["DESIRED_PRICE"]);
              }
              //Card representing the game
              return Card(
                color: Colors.blueGrey[300],
                //Tiles creation
                child: ListTile(
                  title: Text(_data[index]["NAME"]),
                  onTap: () async {
                    bool connectionStatus = false;
                    await _connectivity.checkConnectivity().then((value) {
                      connectionStatus =
                          value == ConnectivityResult.none ? false : true;
                    });

                    //Pop-up dialog on tile click
                    if (!connectionStatus) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return this
                                .dialogFactory
                                .noConnectionDialog(context);
                          });
                    } else {
                      var id = _data[index]["ID"];
                      var name = _data[index]["NAME"];
                      // ignore: prefer_typing_uninitialized_variables
                      var price;
                      late String selectedPrice;
                      //removeFromGameList(id);
                      //Retriving the game price informations
                      await SteamRequest().getGameDetails(id).then((value) {
                        price = value["price_overview"]["final_formatted"];
                      });
                      await SteamRequest().getSelectedPrice(id).then((value) {
                        selectedPrice = value;
                      });

                      showDialog(
                          context: context,
                          builder: (context) {
                            return this.dialogFactory.selectedGamesDialog(
                                id, name, price, selectedPrice, context);
                          });
                    }
                  },
                ),
              );
            }),
          );
        } else {
          //If the db has no data display a Text() message that invite to add a game
          return const Center(
            child: Text(
              "Add a game!",
              style: TextStyle(
                  fontFamily: "font/RobotoMono-Regular.ttf", fontSize: 32.0),
            ),
          );
        }
      },
    ));
  }
}
