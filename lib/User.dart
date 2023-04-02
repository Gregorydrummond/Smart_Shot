import "session.dart";

class User {
  List<Session> sessions = [];
  int userScore = 0;
  double userTime = 0;
  double rating = 0;
  String? name;
  int madeShots = 0;
  int missedShots = 0;
  int swishShots = 0;
  int totalShots = 0;
  int bankShots = 0;
  int hotStreak = 0;
  User(this.name);

  void calculateStats() {
    totalShots = 0;
    missedShots = 0;
    madeShots = 0;
    bankShots = 0;
    swishShots = 0;

    for (int i = 0; i < sessions.length; i++) {
      swishShots += sessions[i].getSwishShots;
      bankShots += sessions[i].bankShots;
      missedShots += sessions[i].missedShots;
      madeShots += sessions[i].madeShots;
      totalShots += sessions[i].getTotalShots;
    }
  }

  double get getRating {
    rating = double.parse(
        (((bankShots + swishShots * 1.5)) / totalShots.toDouble())
            .toStringAsFixed(2));
    return rating;
  }

  double get getShootingPercentage {
    return double.parse(
            (madeShots / totalShots.toDouble()).toStringAsFixed(2)) *
        100;
  }

  double get getTime {
    double time = 0;
    for (var i = 0; i < sessions.length; i++) {
      time += sessions[i].duration;
    }
    return time;
  }
}
