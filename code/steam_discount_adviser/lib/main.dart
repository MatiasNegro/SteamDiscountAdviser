import 'dart:io';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:provider/provider.dart';
import 'package:steam_discount_adviser/utility/allGamesListBuilder.dart';
import 'package:steam_discount_adviser/utility/gameListWidgetBuilder.dart';
import 'package:steam_discount_adviser/utility/providers/dataProvider.dart';
import 'package:steam_discount_adviser/utility/SchedulerFactory.dart';
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

///@nodoc
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Steam Discount Adviser';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: Scaffold(
        body: MainWidget(),
      ),
    );
  }
}

///Main widget, it creates the scheleton of the application dividing it in two separate columns
class MainWidget extends StatelessWidget with TrayListener, WindowListener {
  const MainWidget({Key? key}) : super(key: key);

  ///Adding listeners to the Tray_Manager and the Window_Manager
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
    Menu menu;
    if (!Platform.isLinux) {
      menu = Menu(
        items: [
          MenuItem(
            key: 'exit_app',
            label: 'Exit App',
            onClick: (menuItem) async {
              exit(0);
            },
          ),
        ],
      );
    } else {
      //If the application is working on linux it does not need a menu.
      menu = Menu();
    }

    await trayManager.setContextMenu(menu);
    await windowManager.setMinimumSize(const Size(712.0, 500.0));
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

  ///On linux the package Tray_Manager does not give the [popUpContextMenu()] functionality, but gives the [onTrayIconRightMouse()].
  ///So if the OS is Linux with the mouse right click the application closes.
  ///If the OS is MacOS or Windows, with the right mouse click a menu shows with just the [Exit app] item.
  ///On [Exit app] click the application closes.
  @override
  void onTrayIconRightMouseDown() async {
    if (Platform.isLinux) {
      exit(0);
    } else {
      await trayManager.popUpContextMenu();
    }
  }

  ///[onWindoeClose()] prevent the full close of the application, hiding it and letting it run in background.
  @override
  void onWindowClose() async {
    await windowManager.hide();
    return;
  }

  ///[onTrayIconMouseDown()] shows the application window if it is hidden, else does nothing.
  @override
  void onTrayIconMouseDown() async {
    await windowManager.show();
  }
}
