import 'package:flutter/material.dart';
import 'package:steam_discount_adviser/requests.dart';

class TileList extends StatefulWidget {
  TileList({Key? key}) : super(key: key);

  @override
  State<TileList> createState() => _TileListState();
}

class _TileListState extends State<TileList> {
  late var data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey,
      ),
      child: Scaffold(
        appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.blueGrey[200],
            title: TextField(
              decoration: InputDecoration(
                  border: UnderlineInputBorder(), labelText: "Miao"),
            )),
        backgroundColor: Colors.transparent,
        body: FutureBuilder(
          future: data = SteamRequest().getAllGames(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              data = snapshot.data;
              return ListView.builder(
                itemCount: data.length == 0 ? 0 : data.length,
                itemBuilder: ((BuildContext context, int index) {
                  return Card(
                    color: Colors.blueGrey[300],
                    child: ListTile(title: Text(data[index].toString())),
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
        ),
      ),
    );
  }
}
