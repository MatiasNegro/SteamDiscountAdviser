import 'package:flutter/material.dart';
import 'package:steam_discount_adviser/allGamesListBuilder.dart';
import 'package:steam_discount_adviser/env.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:steam_discount_adviser/Game.dart';
import 'package:steam_discount_adviser/gameListWidgetBuilder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Steam Discount Adviser';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        body: const MyStatelessWidget(),
      ),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          //LEFT COLUMN
          Expanded(
            flex: 3,
            child: Container(
              child: SelectedGames(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey,
              ),
            ),
          ),
          const VerticalDivider(
            width: 10,
            thickness: 1,
            indent: 20,
            endIndent: 0,
            color: Colors.black,
          ),
          Expanded(
            //RIGHT COLUMN
            flex: 7,
            child: Container(
              child: TileList(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
