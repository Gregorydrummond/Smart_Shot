import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:smart_shot/isar_service.dart';
import 'Home.dart';
import 'session.dart';
import 'User.dart';

class SessionList extends StatefulWidget {
  late User user;
  late IsarService service;
  SessionList({super.key, required this.user, required this.service});

  @override
  State<SessionList> createState() => _SessionListState();
}

class _SessionListState extends State<SessionList> {
  int count = 0;
  final int TAB_COUNT = 2;

  void setCount(int newCount) {
    setState(() {
      count = newCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
          length: TAB_COUNT,
          child: Scaffold(
              appBar: AppBar(
                title: const Text('Sessions'),
                backgroundColor: Colors.orangeAccent,
                bottom: const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.list)),
                    Tab(icon: Icon(Icons.calendar_month)),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  sessionListView(widget.user, count, widget.service, setCount),
                  sessionCalendarView(),
                ],
              ))),
    );
  }
}

Widget sessionListView(
        User user, int count, IsarService service, Function function) =>
    SingleChildScrollView(
      child: Column(
        children: [
          TextButton(
              onPressed: () async {
                Session session = Session();
                session.shotTaken(ShotType.swish);
                session.shotTaken(ShotType.miss);
                session.shotTaken(ShotType.swish);
                session.shotTaken(ShotType.miss);
                session.shotTaken(ShotType.bank);
                session.shotTaken(ShotType.bank);
                session.endSession(user);
                session.duration = 10.0;
                service.saveSession(session);

                // Put back in class
                List<Session> list = await service.getAllSessions();
                function(list.length);

                // setState(() {
                //   count = list.length;
                // });
              },
              child: Text('Add Session')),
          Text(count.toString()),
          TextButton(
              onPressed: () async {
                await service.cleanDb();
                function(0);
                // setState(() {
                //   count = 0;
                // });
              },
              child: Text('Clean DB')),
          FutureBuilder<List<Session>>(
              future: service.getAllSessions(),
              builder: (context, AsyncSnapshot<List<Session>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return Center(
                        child: Container(
                            margin: EdgeInsets.only(top: 12.0),
                            child: const Text('There are no sessions',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ))));
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                          children: (snapshot.data!)
                              .map((session) => SessionCard(
                                  session)) // TODO: Make session card its own class
                              .toList()),
                    );
                  }
                } else {
                  return CircularProgressIndicator();
                }
              })
        ],
      ),
    );

Widget sessionCalendarView() => const Icon(Icons.calendar_month);

class SessionCard extends StatelessWidget {
  final service = IsarService();
  final Session session;
  SessionCard(this.session);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SessionDetails(session)));
      },
      child: Card(
          elevation: 10,
          color: Colors.orangeAccent,
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.black,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Total Shots: ${session.totalShots}',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(
                      width: 12,
                    ),
                    Text('Shot Percentage: ${session.shotPercentage * 100}%',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Text(
                        'Stats: ${session.getShotPercentage}/${session.getTotalMakes}/${session.getTotalShots}',
                        style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))
                  ],
                )
              ],
            ),
          )),
    );
  }
}

class SessionDetails extends StatelessWidget {
  Session session;
  SessionDetails(this.session, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Session Details'),
      ),
      body: Column(
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
                child:
                    dataAndLabelBox(session.getShotPercentage * 100, "Shot %"),
              ),
              Expanded(
                child: dataAndLabelBox(session.getSessionDuration, "Time"),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: dataAndLabelBox(
                    session.getSwishShots.toDouble(), "Swishes"),
              ),
              Expanded(
                child: dataAndLabelBox(
                    session.getTotalMisses.toDouble(), "Misses"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
