import 'package:flutter/material.dart';
import 'package:steam_discount_adviser/requests.dart';
import 'providers/dataProvider.dart';

class DialogFactory {
  Widget SelectedGamesDialog(id, name, price ,context) {
    
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.fromLTRB(
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
  }

  Widget allGamesDialog(id, name, gameInfo, context) {
    return Dialog(
        backgroundColor: Colors.blueGrey[100],
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Container(
                  width: 500,
                  height: 500,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[200],
                    borderRadius: BorderRadius.circular(10),
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
                    Text("Prezzo: " +
                        gameInfo["price_overview"]["final_formatted"]),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                        "Sconto: ${gameInfo["price_overview"]["discount_percent"]}")
                  ],
                ),
                //Button unther row with text
                ElevatedButton(
                    onPressed: () {
                      Map item = {"id": id, "name": name};
                      context.read<GameList>().addToGameList(item);
                    },
                    child: const Text("Add game to list"))
              ],
            )));
  }

  Widget allGamesDialogFree(id, name, context) {
    return Dialog(
        backgroundColor: Colors.blueGrey[100],
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
            width: 100.0,
            height: 100.0,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const Center(
                  child: Text("this game is free!"),
                )
              ],
            )));
  }
}
