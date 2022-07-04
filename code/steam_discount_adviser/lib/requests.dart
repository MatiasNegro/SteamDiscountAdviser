import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:dio2/dio2.dart';
import 'package:steam_discount_adviser/env.dart';

class SteamRequest {
  //Not tested yet
  Future<List<Map>> getAllGames() async {
    var response = await Dio().get(getAllGamesApi);
    late List<Map> toReturn = [];
    //Viene restituita una stringa
    var data = json.decode(response.data);
    toReturn = response.data["applsit"]["apps"];
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
