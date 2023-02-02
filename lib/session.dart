import 'package:smart_shot/Session.dart';
import 'package:smart_shot/User.dart';

enum ShotType { make, miss }

class Session {
  int totalShots = 0;
  late int madeShots = 0;
  late int missedShots = 0;
  double shotPercentage = 0;
  //List<int> shots = [];
  late DateTime startTime;
  late Duration duration;
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

    // Get duration
    duration = startTime.difference(endTime);

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
  Duration get getSessionDuration {
    return duration;
  }

  // Return rating
  double get getSessionRating {
    return rating;
  }
}
