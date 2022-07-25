import 'dart:convert';

class Game {
  late String code;
  late String name;
  late var info;
  late String price;
  late String imageUrl;
  late var selectedPrice;
  late var standardPrice;

  Game(code, name, info) {
    this.code = code.toString();
    this.name = name.toString();
    this.info = info;
    setInfo();
    print(this.price);
    print(this.imageUrl);
    print("---");
  }

  String getId() {
    return this.code;
  }

  String getName() {
    return this.name;
  }

  void setInfo() {
    this.price = info[getId()]["data"]["price_overview"]["final_formatted"];
    this.imageUrl = info[getId()]["data"]["header_image"];
    this.standardPrice =
        info[getId()]["data"]["price_overview"]["initial_formatted"];
  }
}
