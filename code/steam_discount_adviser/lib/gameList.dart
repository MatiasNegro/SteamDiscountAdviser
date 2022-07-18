import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class GameList {
  String fileName = "./assets/selectedGames.json";
  late List<Game> selectedGames = [];

  GameList() {
    fillList();
  }

  void fillList() async {
    var dataString = await rootBundle.loadString(fileName);
    var data = jsonDecode(dataString);
    List dataList = data["games"];
    for (var item in dataList) {
      selectedGames.add(new Game(item["code"]));
    }
    print(selectedGames[0].getCode() + " " + selectedGames[1].getCode());
  }
}

class Game {
  late String code;

  Game(code) {
    this.code = code.toString();
  }

  String getCode() {
    return this.code;
  }
}
