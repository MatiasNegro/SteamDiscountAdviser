import 'dart:convert';

import 'package:steam_discount_adviser/requests.dart';

class Game {
  late String code;
  late String name;
  late var info;
  late String price;
  late String imageUrl;
  late var selectedPrice;
  late var standardPrice;

  Game(code, name) {
    this.code = code.toString();
    this.name = name.toString();
    setInfo(code);
    print("$name costa $price");
  }

  String getId() {
    return code;
  }

  String getName() {
    return name;
  }

  String getInfo() {
    return info;
  }

  void setData(jsonInfo) {
    price = jsonInfo["price_overview"]["final_formatted"];
    imageUrl = jsonInfo["header_image"];
    standardPrice = jsonInfo["price_overview"]["initial_formatted"];
  }

  void setInfo(code) async {
    info = await SteamRequest().getGameDetails(code).then(
      (value) {
        print(value);
        setData(value);
        print("---");
        return;
      },
    );
  }
}
