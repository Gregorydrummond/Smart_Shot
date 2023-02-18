import 'package:isar/isar.dart';
import 'package:smart_shot/session.dart';

class IsarService {
  late Future<Isar> db;

  //coonstructor that calls database (db)
  IsarService() {
    db = openDB();
  }

  //save session created
  Future<void> saveSession(Session newSession) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.sessions.putSync(newSession));
  }

  //get all sessions stored
  Future<List<Session>> getAllSessions() async {
    final isar = await db;
    return await isar.sessions.where().findAll();
  }

  //listen to sessions to show actual information
  Stream<List<Session>> listenToSessions() async* {
    final isar = await db;
    yield* isar.sessions.where().watch(initialReturn: true);
  }

  //cleans database if needed
  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  //test function to retrieve shots above certain percentage
  Future<List<Session>> getSessionsFor(Session session) async {
    final isar = await db;
    return await isar.sessions
        .filter()
        .shotPercentageGreaterThan(session.shotPercentage)
        .findAll();
  }

  //Set up database when app starts
  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [SessionSchema],
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }
}
