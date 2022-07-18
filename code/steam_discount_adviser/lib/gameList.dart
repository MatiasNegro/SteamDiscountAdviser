import 'dart:io';
import 'dart:async';

class GameList {
  String fileName = "selectedGames.txt";
  late List<Game> selectedGames = [];
  late var myFile = () async {
    if (await checkExistance()) {
      return File(fileName);
    }
    var tempFile = File(fileName).create();
    return tempFile;
  };
  
  GameList(){
    
  }

  Future<bool> checkExistance() async {
    var tempFile;
    if (tempFile(fileName).exists()) return true;
    return false;
  }
}

class Game {
  late String name;
  late String code;

  Game(name, code) {
    this.name = name;
    this.code = code;
  }

  String getName() {
    return this.name;
  }

  String getCode() {
    return this.code;
  }
}
