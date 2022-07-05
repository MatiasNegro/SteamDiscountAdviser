import 'dart:convert';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:steam_discount_adviser/env.dart';

class SteamRequest {
  //Not tested yet
  Future<List> getAllGames() async {
    var dio = Dio();
    var response = await dio.get(getAllGamesApi);
    late var toReturn;
    //Viene restituita una stringa
    var data = response.data;
    var appList = data["applist"];
    toReturn = appList["apps"];
    print(toReturn.runtimeType);
    //print(toReturn[5]);
    return toReturn;
  }

  //Not tested yet
  Future<Map> getGameDetails(id) async {
    var response = await Dio().get(getAllGamesApi);
    late Map toReturn = {};

    var data = json.decode(response.data);
    toReturn = data;
    return toReturn;
  }
}
