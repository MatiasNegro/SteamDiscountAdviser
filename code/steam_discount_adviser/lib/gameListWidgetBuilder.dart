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
    if (context.watch<GameList>().hasChanged) {
      setState(() {
        context.watch<GameList>().displayedData;
      });
    }
    return context.watch<GameList>().displayedData;
  }
}
