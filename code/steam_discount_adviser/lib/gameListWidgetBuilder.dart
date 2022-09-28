import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:steam_discount_adviser/allGamesListBuilder.dart';
import 'package:steam_discount_adviser/Game.dart';
import 'dart:async';
import 'package:steam_discount_adviser/requests.dart';
import 'package:steam_discount_adviser/providers/dataProvider.dart';

class SelectedGames extends StatefulWidget {
  SelectedGames({Key? key}) : super(key: key);

  @override
  State<SelectedGames> createState() => _SelectedGamesState();
}

class _SelectedGamesState extends State<SelectedGames> {
  late var data;

  @override
  void initState() {
    data = SteamRequest().getSelectedGames();
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
            SizedBox(
              height: 10,
            ),
            Center(
              child: Image(
                image: AssetImage('./assets/images/temp_logo.png'),
                height: 250,
                width: 250,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
                child: FutureBuilder(
              future: data,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  data = snapshot.data;

                  //print(data.toString());
                  return ListView.builder(
                    controller: ScrollController(),
                    itemCount: data.length == 0 ? 0 : data.length,
                    itemBuilder: ((BuildContext context, int index) {
                      return Card(
                        color: Colors.blueGrey[300],
                        child: ListTile(
                          title: Text(data[index].getName()),
                          onTap: () async {
                            var id = data[index].getId();
                            var name = data[index].getName();
                            var gameInfo =
                                await SteamRequest().getGameDetails(550);
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
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 10, 10, 10),
                                                decoration: BoxDecoration(
                                                  color: Colors.blueGrey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  name,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text("Prezzo: " +
                                                      gameInfo["price_overview"]
                                                          ["final_formatted"]),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("Sconto: " +
                                                      gameInfo["price_overview"]
                                                              [
                                                              "discount_percent"]
                                                          .toString())
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
                  return Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.black,
                      )),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey,
                      ));
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
