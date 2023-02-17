import "session.dart";

class User {
  List<Session> sessions = [];
  int userScore = 0;
  double userTime = 0;
  double userRating = 0;
  String name;
  int madeShots = 0;
  int missedShots = 0;
  int totalShots = 0;

  User(this.name);

  double get getShootingPercentage {
    return madeShots / totalShots.toDouble() * 100;
  }
}
