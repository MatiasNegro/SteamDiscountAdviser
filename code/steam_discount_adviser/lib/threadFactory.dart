import 'package:flutter/material.dart';
import 'package:thread/thread.dart';
import 'package:steam_discount_adviser/notificator.dart';
import 'package:cron/cron.dart';

class ThreadFactory {
  // ignore: non_constant_identifier_names
  SteamThread() {
    final cron = Cron();
    cron.schedule(Schedule.parse('* * */1 * * *'), () async {
      var now = DateTime.now().toString().substring(11, 13);
      if (now == "19") {
        SteamNotificator().TimeNotifier();
      }
    });
  }
}
