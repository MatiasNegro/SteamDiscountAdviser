import 'package:local_notifier/local_notifier.dart';
import 'package:steam_discount_adviser/utility/requests.dart';

///Notification system.
///
///Called by [SchedulerFactory] when a game is in discount under the DESIRED_PRICE
///and [Main] on application start.
class SteamNotificator {
  //Notification function
  notify(id, selectedPrice) async {
    LocalNotification notification;
    var response = await SteamRequest().getGameDetails(id);
    //Parsing of the current price of the game to have a univoque format for the price showing.
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

  ///Function used to notify the discount of a game when called by the [SchedulerFactory] system.
  // ignore: non_constant_identifier_names
  TimeNotifier() async {
    await SteamRequest().getSelectedGames().then((value) {
      value.forEach((element) {
        notify(element["ID"], element["DESIRED_PRICE"]);
      });
    });
    return;
  }
}
