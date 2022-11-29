//
// DO-NOT REMOVE THE IMPORTS EVEN IF FLUTTER SAYS THAT ARE USELESS, THEY'RE NOT!
//
import 'dart:core';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:steam_discount_adviser/utility/env.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

///[SteamRequest] gives all the functionality for API calls with the SteamAPI.
class SteamRequest {
  ///[Dio()] is the I/O package for the API requests.
  var dio = Dio();

  ///Returns the list of name and id of every game on steam
  Future<List> getAllGames() async {
    var response = await dio.get(getAllGamesApi);
    late List toReturn;
    //The response is a string, so its converted into a Map
    var data = response.data as Map;
    var appList = data["applist"];
    toReturn = appList["apps"];
    //toRetrun is now a List disguised as a Map, so we can without problems cast it and
    //Filter the games we do not want to appear.
    //Removing elements where there is no name
    toReturn.removeWhere((element) =>
        element["name"].isEmpty ||
        element["appid"] == 216938 ||
        (element["name"] as String).contains("test"));

    return toReturn;
  }

  ///returns the details of a given game
  Future<Map> getGameDetails(id) async {
    var response = await dio.get("$getGameDetailsFromIdApi$id&currency=3");
    late Map toReturn = {};
    toReturn = response.data;
    //The response is cleaned of the useless stuff and the returned value haas just the info
    toReturn = toReturn["$id"]["data"];
    return toReturn;
  }

  ///Returns the games we added to the List. Data is stored inside a sqlite3 database
  ///accessible only by the app.
  Future<List> getSelectedGames() async {
    late String path;
    List toReturn = [];
    if (Platform.isMacOS) {
      path = await getDatabasesPath();
    }

    //Windows and Linux db initialization
    sqfliteFfiInit();

    //If the platform is windows or linux the DB interface is given by a different package instead of the
    //MacOS one
    if (Platform.isWindows || Platform.isLinux) {
      var databaseFactory = databaseFactoryFfi;
      var db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      await db.execute('''
              CREATE TABLE GAMES(ID TEXT PRIMARY KEY, NAME TEXT, DESIRED_PRICE TEXT)
              ''');
      var query = await db.query("GAMES");
      toReturn = query.toList();
      db.close();
    } else {
      //Getting the standard db directory

      //Opening the database
      final Database database = await openDatabase(
        join(path, 'selectedGames.db'),
        //Alwais put the onCreate parameter, if not the db will not return anything even if it exist already
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE GAMES(ID TEXT PRIMARY KEY, NAME TEXT, DESIRED_PRICE TEXT)',
          );
        },
        version: 1,
      );
      //Database interrogation, query is not to make any SQL interrogation but for SELECT only
      var query = await database.query("GAMES");
      //Listing query results
      toReturn = query.toList();
      //Database clousure
      database.close();
    }

    return toReturn;
  }

  ///[getSelectedPrice(String id)] returns the ["SELECTED_PRICE"] field of a give [id] from the
  ///internal database.
  Future<String> getSelectedPrice(id) async {
    late String path;
    double toReturn;
    if (Platform.isMacOS) {
      path = await getDatabasesPath();
    }

    //Windows and Linux db intialization
    sqfliteFfiInit();

    //If the platform is windows or linux the DB interface is given by a different package instead of the
    //MacOS one
    if (Platform.isWindows || Platform.isLinux) {
      var databaseFactory = databaseFactoryFfi;
      var db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      await db.execute('''
              CREATE TABLE GAMES(ID TEXT PRIMARY KEY, NAME TEXT, DESIRED_PRICE TEXT)
              ''');
      var query = await db.query("GAMES",
          columns: ["DESIRED_PRICE"], where: "ID = $id");
      toReturn = double.parse(query[0]["DESIRED_PRICE"].toString());
      db.close();
    } else {
      //Opening the database
      final Database database = await openDatabase(
        join(path, 'selectedGames.db'),
        //Alwais put the onCreate parameter, if not the db will not return anything even if it exist already
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE GAMES(ID TEXT PRIMARY KEY, NAME TEXT, DESIRED_PRICE TEXT)',
          );
        },
        version: 1,
      );
      //Database interrogation, query is not to make any SQL interrogation but for SELECT only
      var query = await database.query("GAMES",
          columns: ["DESIRED_PRICE"], where: "ID = $id");
      //Result parsing to avoid [double.parse()] errors , so we remove the "," character if the user uses
      //it instead of the "." one (if the user puts it).
      toReturn = double.parse(
          (query[0]["DESIRED_PRICE"] as String).contains(',')
              ? (query[0]["DESIRED_PRICE"] as String)
                  .replaceAll(",", ".")
                  .toString()
              : (query[0]["DESIRED_PRICE"].toString()));
      database.close();
    }
    //Reparsing the string for univocque writing style of the prices
    return toReturn.toString().replaceAll(".", ",");
  }
}
