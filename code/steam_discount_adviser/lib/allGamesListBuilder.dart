import 'package:flutter/material.dart';
import 'package:steam_discount_adviser/requests.dart';

class TileList extends StatefulWidget {
  TileList({Key? key}) : super(key: key);

  @override
  State<TileList> createState() => _TileListState();
}

class _TileListState extends State<TileList> {
  late var data;
  late var names;

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
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: "Search game",
                  filled: true,
                  fillColor: Colors.grey[400],
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: data = SteamRequest().getAllGames(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    data = snapshot.data;
                    return ListView.builder(
                      itemCount: data.length == 0 ? 0 : data.length,
                      itemBuilder: ((BuildContext context, int index) {
                        return Card(
                          color: Colors.blueGrey[300],
                          child: ListTile(
                            title: Text(data[index + 19]["name"].toString()),
                            onTap: () {
                              var id = data[index + 19]["appid"];
                              var name = data[index + 19]["name"];
                              print("ho premuto $name");
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
