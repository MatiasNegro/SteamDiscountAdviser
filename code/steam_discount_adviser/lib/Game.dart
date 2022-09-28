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

  Game(code, name, [info = null]) {
    this.code = code.toString();
    this.name = name.toString();
    this.info = info;
    setInfo();
  }

  String getId() {
    return this.code;
  }

  String getName() {
    return this.name;
  }

  void setData() {
    this.price = info[getId()]["data"]["price_overview"]["final_formatted"];
    this.imageUrl = info[getId()]["data"]["header_image"];
    this.standardPrice =
        info[getId()]["data"]["price_overview"]["initial_formatted"];
  }

  void setInfo() async {
    this.info = await SteamRequest().getGameDetails(getId());
    print(this.info);
    setData();
  }
}
