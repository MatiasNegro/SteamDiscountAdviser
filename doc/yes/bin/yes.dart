import 'package:yes/yes.dart' as yes;
import 'dart:async';
import 'package:dio/dio.dart';

void main(List<String> arguments) async {
  var response =
      await Dio().get("https://api.steampowered.com/ISteamApps/GetAppList/v2/");
  late var toReturn;
  //Viene restituita una stringa
  var data = response.data as Map;
  var appList = data["applist"];
  toReturn = appList["apps"];
  var newList = [];
  for (var element in toReturn) {
    newList.add(element["name"]);
  }
  print(newList);
}
