import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steam_discount_adviser/allGamesListBuilder.dart';
import 'package:steam_discount_adviser/gameListWidgetBuilder.dart';
import 'package:steam_discount_adviser/providers/dataProvider.dart';
import 'package:thread/thread.dart';

void main() {
  var thread = Thread(
    (emitter) {
      while (true) {
        print("miao");
      }
    },
  );
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => GameList())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Steam Discount Adviser';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: Scaffold(
        body: MyStatelessWidget(),
      ),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //One page application, the window get divided in two sections, the left occupies the 30% of the window
    //and the right the 70% => $flex=3 and $flex = 7
    return Container(
      color: Colors.blueGrey[900],
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          //LEFT COLUMN
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey,
              ),
              child: SelectedGames(),
            ),
          ),
          //The divider
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey,
              ),
              child: TileList(),
            ),
          ),
        ],
      ),
    );
  }
}
