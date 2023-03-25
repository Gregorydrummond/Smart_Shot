//import 'package:smart_shot/session.dart';
import 'package:smart_shot/User.dart';
import 'package:isar/isar.dart';

part 'session.g.dart';

enum ShotType { swish, bank, miss }

@Collection()
class Session {
  Id id = isarAutoIncrementId;

  int totalShots = 0;
  int madeShots = 0;
  int bankShots = 0;
  int swishShots = 0;
  int missedShots = 0;
  int hotStreak = 0;
  int streak = 0;
  double shotPercentage = 0;
  late DateTime startTime;
  double duration = 0.0;
  double rating = 0.0;

  Session() {
    // Session start time
    startTime = DateTime.now();
  }

  // Track makes, misses, and total shots
  void shotTaken(ShotType shotType) {
    // Make or miss
    switch (shotType) {
      case ShotType.swish:
        madeShots++;
        swishShots++;
        streak++;
        break;
      case ShotType.bank:
        bankShots++;
        madeShots++;
        streak++;
        break;
      case ShotType.miss:
        missedShots++;
        streak = 0;
        break;
      default:
    }

    if(streak > hotStreak){
      hotStreak = streak;
    }

    // Add to total shots
    totalShots++;

    // Update shot percentage
    shotPercentage =
        double.parse((madeShots / totalShots.toDouble()).toStringAsFixed(2));
  }

  // End session
  void endSession(User user) {
    // End time
    DateTime endTime = DateTime.now();
    Duration diff;

    // Get duration
    //duration = startTime.difference(endTime);
    diff = endTime.difference(startTime);
    duration = diff.inSeconds / 60.0;

    // Update user data
    user.madeShots += madeShots;
    user.missedShots += missedShots;
    user.totalShots += totalShots;
    user.bankShots += bankShots;
    user.swishShots += swishShots;

    user.hotStreak = hotStreak;
    rating = ((bankShots + swishShots) * 1.5) / totalShots;
  }

  // Return total shots
  @ignore
  int get getTotalShots {
    return totalShots;
  }

  @ignore
  int get getSwishShots {
    return swishShots;
  }
  @ignore
    int get getHotStreak {
    return hotStreak;
  }

    @ignore
    int get getStreak {
    return streak;
  }

  // Return total makes
  @ignore
  int get getTotalMakes {
    return madeShots;
  }

  // Return total misses
  @ignore
  int get getTotalMisses {
    return missedShots;
  }

  // Return shot percentage
  @ignore
  double get getShotPercentage {
    return shotPercentage;
  }

  // Return duration (End session first) (Should we guard this even though we're the ones writing the code)
  @ignore
  double get getSessionDuration {
    return duration;
  }

  // Return rating
  @ignore
  double get getSessionRating {
    return rating;
  }
}
