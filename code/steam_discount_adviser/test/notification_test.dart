import 'package:test/scaffolding.dart';
import 'package:test/test.dart';
import 'package:steam_discount_adviser/requests.dart';
import 'package:steam_discount_adviser/notificator.dart';

void main() {
  test("Notification testing", () async {
    var element; // Game used to test the notification system
    var expected; // Expected result
    await SteamRequest().getSelectedGames().then((value) {
      value.forEach((element) {
        SteamNotificator().Notify(element["ID"], element["DESIRED_PRICE"]);
      }); // Notification sending
      // We need a method to check if the notification has been sent or not
    });
  });
}
