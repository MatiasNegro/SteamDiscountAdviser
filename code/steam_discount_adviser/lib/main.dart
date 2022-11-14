import 'dart:io';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:provider/provider.dart';
import 'package:steam_discount_adviser/allGamesListBuilder.dart';
import 'package:steam_discount_adviser/gameListWidgetBuilder.dart';
import 'package:steam_discount_adviser/providers/dataProvider.dart';
import 'package:steam_discount_adviser/SchedulerFactory.dart';
import 'package:window_manager/window_manager.dart';
import 'package:tray_manager/tray_manager.dart';

void main() async {
  //Scheduler to notify the user if a game is in discount at 7 PM CEST
  SchedulerFactory().SteamScheduler();
  //Necessary fotn the windowManager
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  //Options of the window
  WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      title: "Steam Discount Adviser");
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
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

class MyStatelessWidget extends StatelessWidget
    with TrayListener, WindowListener {
  const MyStatelessWidget({Key? key}) : super(key: key);

  void initState() {
    trayManager.addListener(this);
    windowManager.addListener(this);
    _init();
  }

  //Setting the icon for the appliction based on the OS
  _init() async {
    await trayManager.setIcon(
      Platform.isWindows
          ? 'assets/images/app_icon_128.ico'
          : 'assets/images/app_icon_128.png',
    );
    //Settings for the trayManager
    Menu menu = Menu(
      items: [
        MenuItem(
          key: 'show_window',
          label: 'Show Window',
        ),
        MenuItem(
          key: 'set_ignore_mouse_events',
          label: 'setIgnoreMouseEvents(false)',
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'exit_app',
          label: 'Exit App',
        ),
      ],
    );
    await trayManager.setContextMenu(menu);
    await windowManager.setMinimumSize(const Size(712.0, 490.0));
  }

  @override
  Widget build(BuildContext context) {
    initState();
    //One page application, the window get divided in two sections, the left occupies the 30% of the window
    //and the right the 70% => $flex=3 and $flex = 7
    return Container(
      constraints: const BoxConstraints(
        minHeight: 800.0,
        minWidth: 600.0,
      ),
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

  @override
  void onWindowClose() async {
    print("chiamato onWindowClose");
    await windowManager.hide();
    return;
  }

  @override
  void onTrayIconMouseDown() async {
    await windowManager.show();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    print("Chiamato show");
    await windowManager.show();
    return;
  }
}
