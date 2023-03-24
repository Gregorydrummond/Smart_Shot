import 'dart:collection';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:smart_shot/isar_service.dart';
import 'package:intl/intl.dart';
import 'StatCard.dart';
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
  }

  showConnectedToast({required String message}) {
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Session>>(
        future: service.getAllSessions(),
        builder: (context, AsyncSnapshot<List<Session>> snapshot) {
          if (snapshot.hasData) {
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
                body: CircularProgressIndicator());
          }
        });
  }
}

///////////////////////////// User card ///////////////////////////////////
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
  Widget _userCardName(String name) => Padding(
    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0, 0),
    child: Text(
          name,
          style: const TextStyle(
            fontSize: 40,
          ),
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
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _userCardName(widget.user.name!),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: StatCard(value: widget.user.getRating, title: 'RATING', type: "",),
              ),
              Expanded(
                child: StatCard(value: widget.user.getTime, title: 'TIME', type: "time",),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//////////////////// Graphs (Bar) for weekly recap ////////////////////////
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
              fontSize: 40,
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

///////////////// Graph (Circular) for quick overview /////////////////////
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
              fontSize: 40,
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


////////////////////////// Most Recent Session ////////////////////////////
class LastSession extends StatefulWidget {
  late List<Session> sessions;
  LastSession(this.sessions);

  @override
  State<LastSession> createState() => _LastSessionState();
}

class _LastSessionState extends State<LastSession> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sessions.isEmpty) {
      return Container();
    }
    return SafeArea(
      child: Column(
        children: [
          const Text(
            'Last Session',
            style: TextStyle(
              fontSize: 40,
            ),
          ),
          Row(
            children: [
              Expanded(child: StatCard(title: "Shot Percent", type: "percent", value: widget.sessions.last.getShotPercentage)),
              Expanded(child: StatCard(title: "Duration", type: "time", value: widget.sessions.last.getSessionDuration)),
            ],
          ),
          Row(
            children: [
              Expanded(child: StatCard(title: "Swishes", type: "count", value: widget.sessions.last.getSwishShots.toDouble())),
              Expanded(child: StatCard(title: "Shots Made", type: "count", value: widget.sessions.last.getTotalMakes.toDouble())),
            ],
          ),
          Row(
            children: [
              Expanded(child: StatCard(title: "Total Shots", type: "count", value: widget.sessions.last.getSwishShots.toDouble())),
              Expanded(child: StatCard(title: "Total Misses", type: "count", value: widget.sessions.last.getTotalMisses.toDouble())),
            ],
          ),
        ],
      ),
    );
  }
}
