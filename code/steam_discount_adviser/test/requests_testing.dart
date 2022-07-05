import 'package:steam_discount_adviser/requests.dart';
import 'package:test/test.dart';

void main() {
  test('getAllGames should retrive a json with all game names and their id',
      () async {
    List myJson = await SteamRequest().getAllGames();
    var matcher = myJson[5];
    expect(matcher["name"], equals("test2"));
  });
}
