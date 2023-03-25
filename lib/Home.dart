import 'dart:collection';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:smart_shot/isar_service.dart';
import 'package:intl/intl.dart';
import 'User.dart';
import 'session.dart';
import 'ConnectDevice.dart';
import 'package:intl/intl.dart';

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
              // drawer: Drawer(
              //   child: ListView(
              //     padding: EdgeInsets.zero,
              //     children: [
              //       const DrawerHeader(
              //         decoration: BoxDecoration(
              //           color: Colors.orangeAccent,
              //         ),
              //         child: Text(
              //           'SmartShot Menu',
              //           style: TextStyle(
              //             fontSize: 40,
              //           ),
              //         ),
              //       ),
              //       ListTile(
              //         title: const Text(
              //           'Connect Device',
              //         ),
              //         onTap: () {
              //           // Close navigation drawer
              //           // Navigator.pop(context);
              //           // Navigator.of(context).push(MaterialPageRoute(
              //           //   builder: (context) =>
              //           //       ConnectDevice(onConnection: showConnectedToast),
              //           // ));
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    UserCard(widget.user, snapshot.data!),
                    WeeklyRecapGraph(snapshot.data!),
                    RatingRecapGraph(widget.user, snapshot.data!),
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
                            builder: (context) =>
                                ConnectDevice(onConnection: showConnectedToast),
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
                      child: dataAndLabelBox(widget.user.getRating, 'RATING'),
                    ),
                    Expanded(
                      child: dataAndLabelBox(widget.user.getTime, 'TIME'),
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
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    // Get data
    chartData = getChartData(widget.sessions);
    _tooltipBehavior =TooltipBehavior(enable: true);
    super.initState();
  }

  List<SessionData> getChartData(List<Session> sessions) {
    // Get at most the last 7 sessions
    // if (sessions.length > 7) {
    //   weeklySession = sessions.sublist(sessions.length - 7);
    // } else {
       weeklySession = sessions;
    // }

    List<SessionData> chartData = [];

    // Create Session data objects that have the days and the ratings
    for (var session in weeklySession) {
      DateTime date = session.startTime;
      //String day = DateFormat('Md').format(date); // Gets the day name
      if(session.getShotPercentage >= .70){
      chartData.add(SessionData(date, (session.getShotPercentage*100).round(), Colors.green));
      }
       else if(session.getShotPercentage >= .50) {
      chartData.add(SessionData(date, (session.getShotPercentage*100).round(), Colors.yellow));
       }
      else if(session.getShotPercentage >= .35){
      chartData.add(SessionData(date, (session.getShotPercentage*100).round(), Colors.orange));
      }

      else {
      chartData.add(SessionData(date, (session.getShotPercentage*100).round(), Colors.red));
      }

    }

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Column(
        children: [
          const Text(
            'Performance Overview',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
                  SfCartesianChart(
            tooltipBehavior: _tooltipBehavior,
            isTransposed: false,
            
            series: <ChartSeries>[
              ScatterSeries<SessionData, DateTime>(
                dataSource: chartData,
                // trendlines:<Trendline>[
                //   Trendline(
                //   type: TrendlineType.linear, 
                //   color: Colors.blue)
                // ],
                xValueMapper: (SessionData sessionData, _) => sessionData.day,
                yValueMapper: (SessionData sessionData, _) => sessionData.rating,
                enableTooltip: true,
                pointColorMapper: (SessionData sessionData, _) => sessionData.color,
              ),
            ],
            primaryXAxis: DateTimeAxis(
              intervalType: DateTimeIntervalType.days,
              //interval: 0.5,
              //dateFormat: DateFormat.MMMM(),
              rangePadding: ChartRangePadding.additional
            // zoomFactor: .5
            ),
            primaryYAxis: NumericAxis(
              labelFormat: '{value}%',
              maximum: 105
               ),

          ),
        ],
      ),
    );
  }
}


          // SfCartesianChart(
          //   isTransposed: false,
          //   series: <ChartSeries>[
          //     BarSeries<SessionData, String>(
          //       dataSource: chartData,
          //       xValueMapper: (SessionData sessionData, _) => sessionData.day,
          //       yValueMapper: (SessionData sessionData, _) =>
          //           sessionData.rating,
          //     ),
          //   ],
          //   primaryXAxis: CategoryAxis(),
          // ),


class SessionData {
  DateTime day;
  int rating;
  Color color;
  SessionData(this.day, this.rating, this.color);
}



class RatingRecapGraph extends StatefulWidget {
   late User user;
  late List<Session> sessions;
  RatingRecapGraph(this.user, this.sessions);

  @override
  State<RatingRecapGraph> createState() => _RatingRecapGraphState();
}

class _RatingRecapGraphState extends State<RatingRecapGraph> {
  late List<Session> ratingSession;
  late List<SessionData1> chartData;
  late TooltipBehavior _tooltipBehavior;
  double userRating = 0;
  @override
  void initState() {
    // Get data
    chartData = getChartData(widget.sessions);
    _tooltipBehavior =TooltipBehavior(enable: true);

       widget.user.sessions = widget.sessions;
    widget.user.calculateStats();
    // Get data
    userRating = widget.user.getRating;

    super.initState();
   
  }

  List<SessionData1> getChartData(List<Session> sessions) {
    ratingSession = sessions;

    List<SessionData1> chartData = [];

    // Create Session data objects that have the days and the ratings
    int count =0;
    double rating =0.0;
    int bank = 0;
    int swish = 0;
    int total = 0;
    for (var session in ratingSession) {
      DateTime date = session.startTime;
      //String day = DateFormat('Md').format(date); // Gets the day name

      if (count != 0){
        rating =  double.parse(
        ((((bank + session.bankShots) + (swish + session.swishShots) * 1.5)) / (total + session.totalShots).toDouble())
            .toStringAsFixed(2)) * 100;
      }
      else {rating = session.getSessionRating *100;}

      count++;
      chartData.add(SessionData1(date, (rating).round(), Colors.blue));
      bank += session.bankShots;
      swish += session.swishShots;
      total += session.totalShots;
    }
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Column(
        children: [
          const Text(
            'Rating Overview',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
                  SfCartesianChart(
            tooltipBehavior: _tooltipBehavior,
            isTransposed: false,
            
            series: <ChartSeries>[
              LineSeries<SessionData1, DateTime>(
                dataSource: chartData,
                xValueMapper: (SessionData1 sessionData1, _) => sessionData1.day,
                yValueMapper: (SessionData1 sessionData1, _) => sessionData1.rating,
                enableTooltip: true,
                pointColorMapper: (SessionData1 sessionData1, _) => sessionData1.color,
              ),
            ],
             primaryXAxis: DateTimeAxis(
             // intervalType: DateTimeIntervalType.days,
              //interval: 0.5,
              //dateFormat: DateFormat.MMMM(),
              rangePadding: ChartRangePadding.auto
            // zoomFactor: .5
            ),
            primaryYAxis: NumericAxis(
              
             // labelFormat: '{value}%',
              decimalPlaces: 2,
              maximum: 170
               ),

          ),
        ],
      ),
    );
  }
}

class SessionData1 {
  DateTime day;
  int rating;
  Color color;
  SessionData1(this.day, this.rating, this.color);
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
            'Lifetime Shots',
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
              fontSize: 30,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: dataAndLabelBox(
                    widget.sessions.last.getShotPercentage * 100, "Shot %"),
              ),
              Expanded(
                child: dataAndLabelBox(
                    widget.sessions.last.getSessionDuration, "Time"),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: dataAndLabelBox(
                    widget.sessions.last.getSwishShots.toDouble(), "Swishes"),
              ),
              Expanded(
                child: dataAndLabelBox(
                    widget.sessions.last.getTotalMisses.toDouble(), "Misses"),
              ),
            ],
          ),
            Row(
            children: [
              
              Expanded(
                child: dataAndLabelBox(
                    widget.sessions.last.getHotStreak.toDouble(), "Longest Streak"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
