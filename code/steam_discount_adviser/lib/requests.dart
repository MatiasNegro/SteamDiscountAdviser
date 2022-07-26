import 'dart:convert';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:steam_discount_adviser/env.dart';
import 'package:test/expect.dart';
import 'package:steam_discount_adviser/Game.dart';
import 'package:flutter/services.dart' show rootBundle;

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
    var response = await dio.get(getGameDetailsFromIdApi + "$id");
    late Map toReturn = {};
    toReturn = response.data;
    return toReturn;
  }

  Future<List> getSelectedGames() async {
    var dataString = await rootBundle.loadString(fileName);
    var data = jsonDecode(dataString);
    var toReturn = [];
    List dataList = data["games"];
    dataList.forEach((item) async {
        toReturn.add(new Game(item["code"], item["name"]));
      });
      return toReturn;
  }
}
