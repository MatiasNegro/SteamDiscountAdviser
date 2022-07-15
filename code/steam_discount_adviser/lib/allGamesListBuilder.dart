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
  late var dataBackup;
  List results = [];
  bool flag = false;

  @override
  void initState() {
    super.initState();
    data = SteamRequest().getAllGames();
    setBackUp();
  }

  void setBackUp() async {}

  void _runFilter(String enteredKeyword) {
    if (!flag) {
      dataBackup = List.from(data);
    }
    results = List.from(dataBackup);
    if (data != []) {
      results = List.from(dataBackup);
      if (enteredKeyword.isEmpty) {
        results = List.from(dataBackup);
      } else {
        results.removeWhere((element) => !(element["name"] as String)
            .toLowerCase()
            .contains(enteredKeyword));
        // we use the toLowerCase() method to make it case-insensitive
      }

      // Refresh the UI
      flag = true;
      setState(() {
        data = List.from(results);
      });
    }
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
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                onChanged: (value) {
                  _runFilter(value);
                },
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
              child: !flag
                  ? FutureBuilder(
                      future: data,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          data = snapshot.data;
                          return ListView.builder(
                            itemCount: data.length == 0 ? 0 : data.length,
                            itemBuilder: ((BuildContext context, int index) {
                              return Card(
                                color: Colors.blueGrey[300],
                                child: ListTile(
                                  title: Text(data[index]["name"]),
                                  onTap: () {
                                    var id = data[index]["appid"];
                                    var name = data[index]["name"];
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
                    )
                  : ListView.builder(
                      itemCount: (data as List).length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.blueGrey[300],
                          child: ListTile(
                            title: Text(data[index]["name"]),
                            onTap: () {
                              var id = data[index]["appid"];
                              var name = data[index]["name"];
                              print("ho premuto $name");
                            },
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
