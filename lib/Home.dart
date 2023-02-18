import 'dart:collection';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:smart_shot/isar_service.dart';
import 'package:intl/intl.dart';
import 'User.dart';
import 'session.dart';
import 'ConnectDevice.dart';

class Home extends StatefulWidget {
  late User user;
  Home({super.key, required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final service = IsarService();

  @override
  void initState() {
    super.initState();

    // Insert load data logic
    // Create fake data
    //createSessions();
    //calculateUserRating(player.sessions);
  }

  showConnectedToast() {
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("SmartShot Device Connected!"),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Session>>(
        future: service.getAllSessions(),
        builder: (context, AsyncSnapshot<List<Session>> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.orangeAccent,
                title: const Text(
                  'Home',
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.bluetooth),
                    tooltip: "Connect to SmartShot device",
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ConnectDevice(
                          onConnection: showConnectedToast,
                        ),
                      ));
                    },
                  )
                ],
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                      ),
                      child: Text(
                        'SmartShot Menu',
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'Connect Device',
                      ),
                      onTap: () {
                        // Close navigation drawer
                        // Navigator.pop(context);
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) =>
                        //       ConnectDevice(onConnection: showConnectedToast),
                        // ));
                      },
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    UserCard(widget.user, snapshot.data!),
                    WeeklyRecapGraph(snapshot.data!),
                    OverviewRecapGraph(widget.user, snapshot.data!),
                    LastSession(snapshot.data!),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.orangeAccent,
                  title: const Text(
                    'Home',
                  ),
                ),
                drawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                        ),
                        child: Text(
                          'SmartShot Menu',
                          style: TextStyle(
                            fontSize: 40,
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'Connect Device',
                        ),
                        onTap: () {
                          // Close navigation drawer
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ConnectDevice(
                                onConnection: showConnectedToast()),
                          ));
                        },
                      ),
                    ],
                  ),
                ),
                body: CircularProgressIndicator());
          }
        });
  }

  // void createSessions() {
  //   List<Session> sessions = [
  //     Session(12, 0.25, <int>[2, 1, 1, 2, 1, 0, 1, 1, 2, 1, 1, 1],
  //         DateTime.utc(2023, 1, 1), 97.0),
  //     Session(12, 0.25, <int>[2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
  //         DateTime.utc(2023, 1, 2), 98.0),
  //     Session(12, 0.25, <int>[2, 1, 1, 0, 1, 1, 1, 0, 2, 1, 0, 0],
  //         DateTime.utc(2023, 1, 3), 72.0),
  //     Session(12, 0.25, <int>[0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0],
  //         DateTime.utc(2023, 1, 4), 33.0),
  //     Session(12, 0.25, <int>[2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
  //         DateTime.utc(2023, 1, 5), 98.0),
  //     Session(12, 0.25, <int>[2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
  //         DateTime.utc(2023, 1, 6), 98.0),
  //     Session(12, 0.25, <int>[2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
  //         DateTime.utc(2023, 1, 7), 98.0),
  //     Session(12, 0.25, <int>[2, 0, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
  //         DateTime.utc(2023, 1, 8), 95.0),
  //     Session(12, 0.25, <int>[2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
  //         DateTime.utc(2023, 1, 9), 98.0),
  //     Session(12, 0.25, <int>[2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
  //         DateTime.utc(2023, 1, 10), 98.0),
  //     Session(12, 0.25, <int>[2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
  //         DateTime.utc(2023, 1, 11), 98.0),
  //     Session(12, 0.25, <int>[2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
  //         DateTime.utc(2023, 1, 12), 98.0),
  //   ];
  //   player.sessions.addAll(sessions);
  // }

  // Bring this back, commented out for testing
  // void calculateUserRating(List<Session> sessions) {
  //   // Go through each session and get the average rating
  //   double ratingSum = 0;
  //   int numOfSession = sessions.length;

  //   for (var session in sessions) {
  //     ratingSum += session.rating;
  //   }

  //   double playerRating = ratingSum / numOfSession;
  //   player.userRating = double.parse(playerRating.toStringAsFixed(1));
  //   //print(playerRating);
  // }
}

// Orange data and label box data
Widget dataAndLabelBox(double data, String label) => Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
      margin: const EdgeInsets.all(10),
      constraints: const BoxConstraints(
        minHeight: 0,
        maxHeight: 100,
      ),
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        border: Border.all(
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              '$data',
              style: const TextStyle(
                fontSize: 40,
              ),
            ),
          ),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );

// User card
class UserCard extends StatefulWidget {
  late User user;
  late List<Session> sessions;
  UserCard(this.user, this.sessions);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  void initState() {
    widget.user.sessions = widget.sessions;
    widget.user.calculateStats();
    super.initState();
  }

  // User card name
  Widget _userCardName(String name) => Text(
        name,
        style: const TextStyle(
          fontSize: 35,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      constraints: const BoxConstraints(
        minHeight: 0,
        maxHeight: 200,
      ),
      padding: const EdgeInsets.all(5),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: SizedBox(
            //width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _userCardName(widget.user.name),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: dataAndLabelBox(
                          widget.sessions.length.toDouble(), 'SESSIONS'),
                    ),
                    Expanded(
                      child: dataAndLabelBox(widget.user.userTime, 'TIME'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Graphs (Bar) for weekly recap
class WeeklyRecapGraph extends StatefulWidget {
  late List<Session> sessions;
  WeeklyRecapGraph(this.sessions);

  @override
  State<WeeklyRecapGraph> createState() => _WeeklyRecapGraphState();
}

class _WeeklyRecapGraphState extends State<WeeklyRecapGraph> {
  late List<Session> weeklySession;
  late List<SessionData> chartData;

  @override
  void initState() {
    // Get data
    chartData = getChartData(widget.sessions);

    super.initState();
  }

  List<SessionData> getChartData(List<Session> sessions) {
    // Get at most the last 7 sessions
    if (sessions.length > 7) {
      weeklySession = sessions.sublist(sessions.length - 7);
    } else {
      weeklySession = sessions;
    }

    List<SessionData> chartData = [];

    // Create Session data objects that have the days and the ratings
    for (var session in weeklySession) {
      DateTime date = session.startTime;
      String day = DateFormat('jm').format(date); // Gets the day name
      chartData.add(SessionData(day, session.madeShots));
    }

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Text(
            'Weekly Recap',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          SfCartesianChart(
            isTransposed: false,
            series: <ChartSeries>[
              BarSeries<SessionData, String>(
                dataSource: chartData,
                xValueMapper: (SessionData sessionData, _) => sessionData.day,
                yValueMapper: (SessionData sessionData, _) =>
                    sessionData.rating,
              ),
            ],
            primaryXAxis: CategoryAxis(),
          ),
        ],
      ),
    );
  }
}

class SessionData {
  String day = "";
  int rating;

  SessionData(this.day, this.rating);
}

// Graph (Circular) for quick overview
class OverviewRecapGraph extends StatefulWidget {
  late User user;
  late List<Session> sessions;
  OverviewRecapGraph(this.user, this.sessions);

  @override
  State<OverviewRecapGraph> createState() => _OverviewRecapGraphState();
}

class _OverviewRecapGraphState extends State<OverviewRecapGraph> {
  int madeShots = 0;
  int missedShots = 0;
  double shotPercentage = 0;

  List<UserData> chartData = [];

  @override
  void initState() {
    widget.user.sessions = widget.sessions;
    widget.user.calculateStats();
    // Get data
    shotPercentage = widget.user.getShootingPercentage;
    madeShots = widget.user.madeShots;
    missedShots = widget.user.missedShots;

    // Make chart data
    getChartData();

    super.initState();
  }

  void getChartData() {
    chartData = [
      UserData('Made Shots', madeShots, Color(0xff6ee810)),
      UserData('Missed Shots', missedShots, Color(0xffe81010))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          SfCircularChart(
            legend: Legend(
              isVisible: true,
              toggleSeriesVisibility: false,
              borderColor: Colors.black,
              borderWidth: 2,
            ),
            series: <CircularSeries>[
              DoughnutSeries<UserData, String>(
                dataSource: chartData,
                pointColorMapper: (UserData data, _) => data.color,
                xValueMapper: (UserData data, _) => data.label,
                yValueMapper: (UserData data, _) => data.amount,
                innerRadius: "60%",
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
              ),
            ],
            annotations: <CircularChartAnnotation>[
              CircularChartAnnotation(
                height: '100%',
                width: '100%',
                widget: Container(
                  child: PhysicalModel(
                    child: Container(),
                    shape: BoxShape.circle,
                    elevation: 10,
                    shadowColor: Colors.black,
                    color: Colors.white,
                  ),
                ),
              ),
              CircularChartAnnotation(
                widget: Container(
                  child: Text(
                    '$shotPercentage%',
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserData {
  String label = "";
  int amount;
  final Color color;

  UserData(this.label, this.amount, this.color);
}

class LastSession extends StatefulWidget {
  late List<Session> sessions;
  LastSession(this.sessions);

  @override
  State<LastSession> createState() => _LastSessionState();
}

class _LastSessionState extends State<LastSession> {
  late Session lastSession;

  @override
  void initState() {
    // Get data
    if (widget.sessions.isNotEmpty) {
      lastSession = widget.sessions.last;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Text(
            'Last Session',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: dataAndLabelBox(32, "Shot %"),
              ),
              Expanded(
                child: dataAndLabelBox(15, "Time"),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: dataAndLabelBox(17, "Swishes"),
              ),
              Expanded(
                child: dataAndLabelBox(5, "Airballs"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
