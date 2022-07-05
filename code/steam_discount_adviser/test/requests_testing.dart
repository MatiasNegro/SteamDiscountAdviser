import 'package:steam_discount_adviser/requests.dart';
import 'package:test/test.dart';

void main() {
  test('getAllGames should retrive a json with all game names and their id',
      () async {
    var myJson = await SteamRequest().getAllGames();
    var matcher = myJson[5];
    expect(matcher["name"].toString(), equals("test2"));
  });

  test("getGameDetails should give back the details of a game from its id",
      () async {
    String name = "Sight and Sound Town";
    String id = "1924700";
    var toCompare = await SteamRequest().getGameDetails(1924700);
    expect(toCompare[id]["data"]["name"], equals(name));
  });
}
