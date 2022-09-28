import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:steam_discount_adviser/env.dart';
import 'package:steam_discount_adviser/Game.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path/path.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';

class SteamRequest {
  var dio = Dio();
  var fileName = "./assets/selectedGames.json";

  //Returns the list of name and id of every game on steam
  Future<List> getAllGames() async {
    var response = await dio.get(getAllGamesApi);
    late var toReturn;
    //Viene restituita una stringa
    var data = response.data as Map;
    var appList = data["applist"];
    toReturn = appList["apps"];
    (toReturn as List).removeWhere((element) => element["name"].isEmpty);
    return toReturn;
  }

  //returns the details of a given game
  Future<Map> getGameDetails(id) async {
    var response =
        await dio.get(getGameDetailsFromIdApi + "$id" + "&currency=3");
    late Map toReturn = {};
    toReturn = response.data;
    toReturn = toReturn["$id"]["data"];
    return toReturn;
  }

  Future<List> getSelectedGames() async {
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
    print(database.toString());
    var query = await (database as Database).query("GAMES");
    var toReturn = [];
    List dataList = query.toList();
    dataList.forEach((item) {
      toReturn.add(new Game(item["ID"], item["NAME"]));
    });
    database.close();
    return toReturn;
  }
}
