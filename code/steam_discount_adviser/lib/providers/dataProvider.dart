import 'package:flutter/material.dart';
import 'package:steam_discount_adviser/requests.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class GameList with ChangeNotifier {
  late final List _data = takeList() as List;
  bool hasChanged = false;

  get gameList => _data;

  Future<List> takeList() async {
    List toReturn = await SteamRequest().getSelectedGames as List;
    return toReturn;
  }

  addToGameList(var item) async {
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
    await database.insert("GAMES", {"ID": item["id"], "NAME": item["name"]});
    hasChanged = true;
    notifyListeners();
    hasChanged = false;
  }

  removeFromGameList(var item) {
    //...
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
}
