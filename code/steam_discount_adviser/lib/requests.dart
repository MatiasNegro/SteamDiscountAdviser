import 'dart:convert';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:steam_discount_adviser/env.dart';

class SteamRequest {
  var dio = Dio();

  //Returns the list of name and id of every game on steam
  Future<List> getAllGames() async {
    var response = await dio.get(getAllGamesApi);
    late var toReturn;
    //Viene restituita una stringa
    var data = response.data as Map;
    var appList = data["applist"];
    toReturn = appList["apps"];
    return toReturn;
  }

  //returns the details of a given game
  Future<Map> getGameDetails(id) async {
    var response = await dio.get(getGameDetailsFromIdApi + "$id");
    late Map toReturn = {};
    toReturn = response.data;
    return toReturn;
  }
}
