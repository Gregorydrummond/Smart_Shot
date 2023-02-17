//import 'package:smart_shot/session.dart';
import 'package:smart_shot/User.dart';
import 'package:isar/isar.dart';

part 'session.g.dart';

enum ShotType { make, miss }

@Collection()
class Session {
  Id id = isarAutoIncrementId;

  int totalShots = 0;
  late int madeShots = 0;
  late int missedShots = 0;
  double shotPercentage = 0;
  //List<int> shots = [];
  late DateTime startTime;
  //late Duration duration;
  late double duration = 0.0;
  late double rating = 0.0;

  Session() {
    // Session start time
    startTime = DateTime.now();
  }

  // Track makes, misses, and total shots
  void shotTaken(ShotType shotType) {
    // Make or miss
    switch (shotType) {
      case ShotType.make:
        madeShots++;
        break;
      case ShotType.miss:
        missedShots++;
        break;
      default:
    }

    // Add to total shots
    totalShots++;

    // Update shot percentage
    shotPercentage = (madeShots / totalShots.toDouble()) * 100;
  }

  // Start session

  // End session
  void endSession(User user) {
    // End time
    DateTime endTime = DateTime.now();
    Duration diff;

    // Get duration
    //duration = startTime.difference(endTime);
    diff = startTime.difference(endTime);
    duration = diff.inSeconds / 60.0;

    // Update user data
    user.madeShots += madeShots;
    user.missedShots += missedShots;
    user.totalShots += totalShots;
  }

  // Return total shots
  int get getTotalShots {
    return totalShots;
  }

  // Return total makes
  int get getTotalMakes {
    return madeShots;
  }

  // Return total misses
  int get getTotalMisses {
    return missedShots;
  }

  // Return shot percentage
  double get getShotPercentage {
    return shotPercentage;
  }

  // Return duration (End session first) (Should we guard this even though we're the ones writing the code)
  double get getSessionDuration {
    return duration;
  }

  // Return rating
  double get getSessionRating {
    return rating;
  }
}
