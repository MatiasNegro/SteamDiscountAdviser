// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:steam_discount_adviser/utility/allGamesListBuilder.dart';
import 'package:steam_discount_adviser/main.dart';
import 'package:steam_discount_adviser/utility/gameListWidgetBuilder.dart';
import 'package:steam_discount_adviser/utility/providers/dataProvider.dart';
import 'package:steam_discount_adviser/utility/SchedulerFactory.dart';

@GenerateMocks([SchedulerFactory])
void main() {
  testWidgets("Right column testing", ((tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => GameList())],
      child: TileList(),
    ));
  }));
}
