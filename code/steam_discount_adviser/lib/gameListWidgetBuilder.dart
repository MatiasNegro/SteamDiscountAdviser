// ignore_for_file: prefer_const_constructors
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steam_discount_adviser/requests.dart';
import 'package:steam_discount_adviser/providers/dataProvider.dart';

class SelectedGames extends StatefulWidget {
  SelectedGames({Key? key}) : super(key: key);

  @override
  State<SelectedGames> createState() => _SelectedGamesState();
}

class _SelectedGamesState extends State<SelectedGames> {
  /// [data] is the result of the db query
  late var data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              future: data = SteamRequest().getSelectedGames(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  isLoading = false;
                  data = snapshot.data;
                  return ListView.builder(
                    controller: ScrollController(),
                    itemCount: data.length,
                    itemBuilder: ((BuildContext context, int index) {
                      return Card(
                        color: Colors.blueGrey[300],
                        //Tiles creation
                        child: ListTile(
                          title: Text(data[index]["NAME"]),
                          onTap: () async {
                            var id = data[index]["ID"];
                            var name = data[index]["NAME"];
                            // ignore: prefer_typing_uninitialized_variables
                            var price;
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
  }
}
