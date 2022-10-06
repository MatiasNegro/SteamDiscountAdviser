import 'package:flutter/material.dart';
import 'package:steam_discount_adviser/requests.dart';
import 'providers/dataProvider.dart';
import 'package:provider/provider.dart';

class DialogFactory {
  final textController = TextEditingController();

  Widget SelectedGamesDialog(id, name, price, BuildContext context) {
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
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          context.read<GameList>().removeFromGameList(id);
                        },
                        child: Center(child: Text("Delete")))
                  ],
                )
              ],
            )));
  }

  Widget allGamesDialog(id, name, gameInfo, BuildContext context) {
    return Dialog(
        backgroundColor: Colors.blueGrey[100],
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
            width: 300.0,
            height: 300.0,
            child: Column(
              children: [
                Container(
                  ///[MediaQuery.of()] is being used to let the window be reactive
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
                Row(
                  children: [
                    // ignore: prefer_interpolation_to_compose_strings
                    Text("Prezzo: " +
                        gameInfo["price_overview"]["final_formatted"]),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                        "Sconto: ${gameInfo["price_overview"]["discount_percent"]}"),
                  ],
                ),
                /*const SizedBox(
                                                        width: 10.0,
                                                        height: 10.0,
                                                      ),*/
                Row(
                  children: [
                    const Text("Price below"),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                      child: SizedBox(
                          width: 50.0,
                          height: 10.0,
                          child: TextField(
                            decoration: const InputDecoration(
                                label: Text(
                              "insert price",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            )),
                            controller: textController,
                          )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                  width: 20.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      var selectedPrice = textController.value.text;
                      Map item = {
                        "id": id,
                        "name": name,
                        "selectedPrice": selectedPrice
                      };
                      context.read<GameList>().addToGameList(item);
                    },
                    child: const Text("Add game to list"))
              ],
            )));
  }

  Widget allGamesDialogFree(id, name, BuildContext context) {
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
