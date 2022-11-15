//
// DO-NOT REMOVE THE IMPORTS EVEN IF FLUTTER SAYS THAT ARE USELESS, THEY'RE NOT!
//
import 'dart:core';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:steam_discount_adviser/env.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// 

class SteamRequest {
  var dio = Dio();

  //Returns the list of name and id of every game on steam
  Future<List> getAllGames() async {
    var response = await dio.get(getAllGamesApi);
    late var toReturn;
    //The response is a string, so its converted into a Map
    var data = response.data as Map;
    var appList = data["applist"];
    toReturn = appList["apps"];
    //toRetrun is now a List disguised as a Map, so we can without problems cast it and
    //Filter the games we do not want to appear.
    //Removing elements where there is no name
    (toReturn as List).removeWhere((element) =>
        element["name"].isEmpty ||
        element["appid"] == 216938 ||
        (element["name"] as String).contains("test"));

    return toReturn;
  }

  //returns the details of a given game
  Future<Map> getGameDetails(id) async {
    var response = await dio.get("$getGameDetailsFromIdApi$id&currency=3");
    late Map toReturn = {};
    toReturn = response.data;
    //The response is cleaned of the useless stuff and the returned value haas just the info
    toReturn = toReturn["$id"]["data"];
    return toReturn;
  }

  //Returns the games we added to the List. Data is stored inside a sqlite3 database
  //accessible only by the app.
  Future<List> getSelectedGames() async {
    String path = await getDatabasesPath();
    List toReturn = [];

    if (Platform.isWindows || Platform.isLinux) {
      var databaseFactory = databaseFactoryFfi;
      var db =
          await databaseFactory.openDatabase(join(path, 'selectedGames.db'));
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

  Future<String> getSelectedPrice(id) async {
    String path = await getDatabasesPath();
    double toReturn;

    if (Platform.isWindows || Platform.isLinux) {
      var databaseFactory = databaseFactoryFfi;
      var db =
          await databaseFactory.openDatabase(join(path, 'selectedGames.db'));
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
      toReturn = double.parse(query[0]["DESIRED_PRICE"].toString());
      database.close();
    }
    return toReturn.toString().replaceAll(".", ",");
  }
}
