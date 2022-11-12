import 'package:flutter/material.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:steam_discount_adviser/requests.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SteamNotificator {
  Notify(id, selectedPrice) async {
    LocalNotification notification;
    var response = await SteamRequest().getGameDetails(id);
    String toParse = response["price_overview"]["final_formatted"]
        .substring(0, response["price_overview"]["final_formatted"].length - 1);
    if (double.parse(toParse.replaceAll(",", ".")) <=
        double.parse(selectedPrice)) {
      String name = response["name"];
      notification = LocalNotification(
        title: "SteamDiscountAdviser",
        body: 'The price of $name is $toParse',
      );
      notification.show();
    }
  }

  // ignore: non_constant_identifier_names
  TimeNotifier() async {
    await SteamRequest().getSelectedGames().then((value) {
      value.forEach((element) {
        Notify(element["ID"], element["DESIRED_PRICE"]);
      });
    });
    return;
  }
}
