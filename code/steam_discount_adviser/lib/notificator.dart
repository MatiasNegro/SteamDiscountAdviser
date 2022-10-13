import 'package:flutter/material.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:steam_discount_adviser/requests.dart';

class SteamNotificator {
  Notify(id, selectedPrice) async {
    var response = await SteamRequest().getGameDetails(id);
    String toParse = response["price_overview"]["final_formatted"]
        .substring(0, response["price_overview"]["final_formatted"].length - 1);
    if (double.parse(toParse.replaceAll(",", ".")) <=
        double.parse(selectedPrice)) {
      String name = response["name"];
      LocalNotification notification = LocalNotification(
        title: "SteamDiscountAdviser",
        body: 'The price of $name is $toParse',
      );
      notification.show();
    }
  }
}
