import 'package:flutter/material.dart';
import 'package:steam_discount_adviser/allGamesListBuilder.dart';

import 'package:steam_discount_adviser/gameList.dart' as gameList;

class SelectedGames extends StatefulWidget {
  SelectedGames({Key? key}) : super(key: key);

  @override
  State<SelectedGames> createState() => _SelectedGamesState();
}

class _SelectedGamesState extends State<SelectedGames> {
  @override
  Widget build(BuildContext context) {
    return TileList();
  }
}