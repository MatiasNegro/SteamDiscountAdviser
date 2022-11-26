import 'package:flutter/material.dart';
import 'providers/dataProvider.dart';
import 'package:provider/provider.dart';
import 'package:steam_discount_adviser/icon.dart';

///[DialogFactory] contains all the Dialog types used in the application.
class DialogFactory {
  ///[textController] is used for all the dialogs where is needed a price.
  final textController = TextEditingController();

  Widget SelectedGamesDialog(
      id, name, price, selectedPrice, BuildContext context) {
    return Dialog(
        backgroundColor: Colors.blueGrey[100],
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
            constraints: const BoxConstraints(minHeight: 140, minWidth: 350),
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      name,
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: "/font/RobotoMono-Regular.ttf"),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, //Center Row contents horizontally,
                  children: [
                    Text(
                      "Price:  $price",
                      style: const TextStyle(
                          fontSize: 16.0,
                          fontFamily: "/font/RobotoMono-Regular.ttf"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    // ignore: prefer_interpolation_to_compose_strings
                    Text(
                      "selected price:  $selectedPrice",
                      style: const TextStyle(
                          fontSize: 16.0,
                          fontFamily: "/font/RobotoMono-Regular.ttf"),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 90, 140, 164)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            context.read<GameList>().removeFromGameList(id);
                          },
                          child: const Icon(TrashBinIcon.trash)),
                      const SizedBox(
                        width: 10.0,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 215, 26, 26)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close))
                    ],
                  ),
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
        child: Container(
            constraints: const BoxConstraints(minHeight: 140, minWidth: 350),
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.35,
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
                        fontFamily: "/font/RobotoMono-Regular.ttf"),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ignore: prefer_interpolation_to_compose_strings
                    Text(
                      // ignore: prefer_interpolation_to_compose_strings
                      "Prezzo:" + gameInfo["price_overview"]["final_formatted"],
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontFamily: "/font/RobotoMono-Regular.ttf",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                        "Sconto: ${gameInfo["price_overview"]["discount_percent"]}",
                        style: const TextStyle(
                            fontSize: 14.0,
                            fontFamily: "/font/RobotoMono-Regular.ttf")),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                  child: SizedBox(
                      width: 180.0,
                      height: 30.0,
                      child: Center(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            bool parsePriceFlag = true;
                            try {
                              if (value != null) {
                                double.parse(value.replaceAll(",", "."));
                              }
                            } catch (Exception) {
                              parsePriceFlag = false;
                            }
                            if (parsePriceFlag) {
                              return null;
                            }

                            return '';
                          },
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            errorStyle: const TextStyle(
                              height: 0,
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(30)),
                            hintText: "Insert desired price",
                            hintStyle: const TextStyle(
                              fontSize: 12.0,
                              fontFamily: "/font/RobotoMono-Regular.ttf",
                            ),
                            filled: true,
                            fillColor: Colors.grey[400],
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            suffixIcon: const Icon(
                              Icons.arrow_circle_right_rounded,
                              color: Colors.black,
                            ),
                          ),
                          controller: textController,
                        ),
                      )),
                ),
                const SizedBox(
                  height: 20.0,
                  width: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 90, 140, 164)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                      ),
                      onPressed: () {
                        try {
                          if (textController.value.text != null) {
                            double.parse(
                                textController.value.text.replaceAll(",", "."));
                          }
                        } catch (Exception) {
                          return;
                        }

                        String selectedPrice = textController.value.text;

                        Map item = {
                          "id": id,
                          "name": name,
                          "selectedPrice": selectedPrice
                        };
                        Navigator.pop(context);
                        context.read<GameList>().addToGameList(item);
                      },
                      child: const Text(
                        "Add game to list",
                        style: TextStyle(
                            fontFamily: "/font/RobotoMono-Regular.ttf"),
                      )),
                )
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
        child: Container(
            constraints: const BoxConstraints(minHeight: 140, minWidth: 350),
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.25,
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
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        fontFamily: "/font/RobotoMono-Regular.ttf"),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Center(
                  child: Text(
                    "this game is free! \u{1F44D}",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: "/font/RobotoMono-Regular.ttf"),
                  ),
                )
              ],
            )));
  }

  //Exception Dialog: When something goes wrong show this dialog

  Widget ExceptionDialog(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.blueGrey[100],
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
            constraints: const BoxConstraints(minHeight: 140, minWidth: 350),
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Sorry for the incovenient",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "/font/RobotoMono-Regular.ttf"),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Center(
                  child: Text(
                    "Something went wrong \u{1F625}",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: "/font/RobotoMono-Regular.ttf"),
                  ),
                )
              ],
            )));
  }

  Widget noConnectionDialog(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.blueGrey[100],
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
            constraints: const BoxConstraints(minHeight: 140, minWidth: 350),
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Sorry for the incovenient",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "/font/RobotoMono-Regular.ttf"),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Center(
                  child: Text(
                    "There is no connection \u{1F625}",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: "/font/RobotoMono-Regular.ttf"),
                  ),
                )
              ],
            )));
  }
}
