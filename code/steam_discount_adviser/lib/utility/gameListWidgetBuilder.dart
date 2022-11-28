// ignore_for_file: prefer_const_constructors
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steam_discount_adviser/utility/providers/dataProvider.dart';

///Left column widget.
///
///This contains the Logo of the application and the [dataProvider()].
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

  ///Main widget
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

            //Main widget, this is the list of selected games
            context.watch<GameList>().displayedData,
          ],
        ),
      ),
    );
  }
}
