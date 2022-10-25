import 'package:flutter/material.dart';
import 'package:thread/thread.dart';
import 'package:steam_discount_adviser/notificator.dart';
import 'package:cron/cron.dart';

class SchedulerFactory {
  // ignore: non_constant_identifier_names
  SteamScheduler() {
    //The schedule ignores the first iteration of controls.
    //On start of the application it starts a 1 hour long clock.
    //Every hour checks if the time is 19 o'clock:
    final cron = Cron();
    cron.schedule(Schedule.parse('* * */1 * * *'), () async {
      var now = DateTime.now().toString().substring(11, 13);
      if (now == "19") {
        //If yes start the notification check
        SteamNotificator().TimeNotifier();
      }
      //Else returns
    });
  }
}
