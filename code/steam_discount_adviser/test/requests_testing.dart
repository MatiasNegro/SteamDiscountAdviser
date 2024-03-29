import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' as ft;
import 'package:steam_discount_adviser/utility/env.dart';
import 'package:steam_discount_adviser/utility/requests.dart';
import 'package:test/test.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dio/dio.dart';

///[em] prefix needed to avoid conflict with Path package

void main() {
  test('getAllGames should retrive a json with all game names and their id',
      () async {
    var response = await Dio().get(getAllGamesApi);
    expect(response.statusCode, 200);
  });

  test("getGameDetails should give back the details of a game from its id",
      () async {
    String name = "Sight and Sound Town";
    String id = "1924700";
    var toCompare = await SteamRequest().getGameDetails(id);
    expect(toCompare["name"], name);
  });
/*
  test('Given a GAMES table, should retrive all games', () async {
    //String path = await getDatabasesPath();
    //Opening the database
    ft.TestWidgetsFlutterBinding.ensureInitialized();
    Database database = await openDatabase(
      inMemoryDatabasePath,
      //Alwais put the onCreate parameter, if not the db will not return anything even if it exist already
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE GAMES(ID TEXT PRIMARY KEY, NAME TEXT, DESIRED_PRICE TEXT)',
        );
      },
      version: 1,
    );

    expect(database.isOpen, true);
  });

  test("Given a game ID in databse return the stored desired price", (() async {
    Database database = await openDatabase(
      inMemoryDatabasePath,
      //Alwais put the onCreate parameter, if not the db will not return anything even if it exist already
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE GAMES(ID TEXT PRIMARY KEY, NAME TEXT, DESIRED_PRICE TEXT)',
        );
      },
      version: 1,
    );

    await database.insert(
        "GAMES", {"ID": "0", "NAME": "Test_Game", "DESIRED_PRICE": "1"});

    String desiredPrice = await database
        .query("GAMES", columns: ["DESIRED_PRICE"], where: "ID = 0")
        .then((value) {
      return value.toList()[0].toString();
    });

    expect(desiredPrice, "1");
  }));*/
}
