import 'package:flutter/material.dart';
import 'package:steam_discount_adviser/requests.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class GameList with ChangeNotifier {
  late var _data;
  bool hasChanged = false;
  late var displayedData = buildListOfGames();

  get gameList => _data;

  Future<List> takeList() async {
    List toReturn = await SteamRequest().getSelectedGames as List;
    return toReturn;
  }

  addToGameList(var item) async {
    String path = await getDatabasesPath();
    final Database database = await openDatabase(
      join(path, 'selectedGames.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE GAMES(ID TEXT PRIMARY KEY, NAME TEXT, DESIRED_PRICE TEXT)',
        );
      },
      version: 1,
    );

    await database.insert("GAMES", {
      "ID": item["id"],
      "NAME": item["name"],
      "DESIRED_PRICE": item["selectedPrice"]
    });
    hasChanged = true;
    displayedData = buildListOfGames();
    notifyListeners();
    hasChanged = false;
    print("in teoria ho fatto");
  }

  removeFromGameList(var id) async {
    String path = await getDatabasesPath();
    final Database database = await openDatabase(
      join(path, 'selectedGames.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE GAMES(ID TEXT PRIMARY KEY, NAME TEXT, DESIRED_PRICE TEXT)',
        );
      },
      version: 1,
    );

    await database.delete("GAMES", where: "ID = ?", whereArgs: [id]);
    hasChanged = true;
    displayedData = buildListOfGames();
    notifyListeners();
    hasChanged = false;
    print("in teoria ho fatto");
  }

  dropGameList() {
    //...
    notifyListeners();
  }

  notifyLeftBuilder() {
    hasChanged = true;
    notifyListeners();
    hasChanged = false;
  }

  Widget buildListOfGames() {
    var isLoading = true;
    var toReturn = Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Sized boxes are there just make space

            //Display the logo of the application
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: RadialGradient(colors: [
                          Colors.blueGrey,
                          Color.fromARGB(255, 2, 18, 45) as Color,
                          Colors.blueGrey[900] as Color,
                        ], radius: 2.0),
                        shape: BoxShape.circle,
                        border: Border.all(width: 2.0)),
                    height: 200,
                    width: 200,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 0.0),
                        child: Text(
                          "Steam Discount Adviser",
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'RobotoMono',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //const SizedBox(height: 10),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey,
                ),
                child: Text(
                  "Selected games",
                  style: TextStyle(
                    fontFamily: "RobotoMono",
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Expanded(
                //Creation of the list.
                child: FutureBuilder(
              ///Retrive of the [data] with db interrogation
              future: _data = SteamRequest().getSelectedGames(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  isLoading = false;
                  _data = snapshot.data;

                  displayedData = ListView.builder(
                    controller: ScrollController(),
                    itemCount: _data.length,
                    itemBuilder: ((BuildContext context, int index) {
                      return Card(
                        color: Colors.blueGrey[300],
                        //Tiles creation
                        child: ListTile(
                          title: Text(_data[index]["NAME"]),
                          onTap: () async {
                            var id = _data[index]["ID"];
                            var name = _data[index]["NAME"];
                            // ignore: prefer_typing_uninitialized_variables
                            var price;
                            removeFromGameList(id);
                            //Retriving the game price informations
                            await SteamRequest()
                                .getGameDetails(id)
                                .then((value) {
                              price =
                                  value["price_overview"]["final_formatted"];
                            });
                            //Pop-up dialog on tile click
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                      backgroundColor: Colors.blueGrey[100],
                                      elevation: 8.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                          width: 100.0,
                                          height: 100.0,
                                          child: Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 10, 10, 10),
                                                decoration: BoxDecoration(
                                                  color: Colors.blueGrey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  name,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  // ignore: prefer_interpolation_to_compose_strings
                                                  Text("Prezzo: " + price),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  // ignore: prefer_interpolation_to_compose_strings
                                                  Text("Sconto: " + price)
                                                ],
                                              ),
                                            ],
                                          )));
                                });
                          },
                        ),
                      );
                    }),
                  );
                  return displayedData;
                } else {
                  //If problems with the database are found, is returned a progress indicator while the app
                  //"searches" a solution
                  return Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey,
                      ),
                      child: const Center(
                          child: CircularProgressIndicator(
                        color: Colors.black,
                      )));
                }
              },
            )),
          ],
        ),
      ),
    );
    return toReturn;
  }
}
