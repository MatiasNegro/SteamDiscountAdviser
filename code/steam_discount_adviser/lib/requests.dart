import 'dart:convert';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:steam_discount_adviser/env.dart';

class SteamRequest {
  var dio = Dio();

  //Not tested yet
  Future<List> getAllGames() async {
    var response = await dio.get(getAllGamesApi);
    late var toReturn;
    //Viene restituita una stringa
    var data = response.data;
    var appList = data["applist"];
    toReturn = appList["apps"];
    return toReturn;
  }

  //Not tested yet
  Future<Map> getGameDetails(id) async {
    var response = await dio.get(getGameDetailsFromIdApi + "$id");
    late Map toReturn = {};
    toReturn = response.data;
    return toReturn;
  }
}
