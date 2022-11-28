import 'package:steam_discount_adviser/utility/notificator.dart';
import 'package:cron/cron.dart';

///Time checking system to notify the user if a game is in discount at 07:00 PM, that is when Steam refresh the
///store with new sales.
class SchedulerFactory {
  // ignore: non_constant_identifier_names
  SteamScheduler() {
    ///The schedule ignores the first iteration of controls.
    ///On start of the application it starts a 1 hour long clock.
    ///Every hour checks if the time is 19 o'clock:
    final cron = Cron();
    cron.schedule(Schedule.parse('* * */1 * * *'), () async {
      var now = DateTime.now().toString().substring(11, 13);
      if (now == "19") {
        //If yes start the notification check
        SteamNotificator().TimeNotifier();
      }
      //Else returns
    });
    cron.close();
  }
}
