class Game {
  late String code;
  late String name;

  Game(code, name) {
    this.code = code.toString();
    this.name = name.toString();
  }

  String getId() {
    return this.code;
  }

  String getName() {
    return this.name;
  }
}
