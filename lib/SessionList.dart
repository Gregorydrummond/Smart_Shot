import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:smart_shot/isar_service.dart';
import 'Home.dart';
import 'SessionDetails.dart';
import 'session.dart';
import 'User.dart';
import 'StatCard.dart';

class SessionList extends StatefulWidget {
  late User user;
  late IsarService service;
  late List<Session> sessions;
  late int count;
  SessionList(
      {super.key,
      required this.user,
      required this.service,
      required this.sessions,
      required this.count});

  @override
  State<SessionList> createState() => _SessionListState();
}

class _SessionListState extends State<SessionList> with SingleTickerProviderStateMixin {
  int count = 0;
  final int TAB_COUNT = 2;
  List<Session> sessions = [];

  @override
  void initState() {
    super.initState();
    sessions = widget.sessions;
    count = widget.count;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
          length: TAB_COUNT,
          child: Scaffold(
              appBar: AppBar(
                title: const Text('Sessions', style: TextStyle(color: Colors.black),),
                backgroundColor: Colors.orangeAccent,
                bottom: const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.list, color: Colors.black,)),
                    Tab(icon: Icon(Icons.calendar_month, color: Colors.black,)),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  sessionListView(widget.user, count, widget.service),
                  Calendar(sessions: sessions),
                ],
              ))),
    );
  }
}

class Calendar extends StatefulWidget {
  late List<Session> sessions;
  Calendar({super.key, required this.sessions});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late List<Session> sessions;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime focusedDay; // = DateTime.now();
  late DateTime currentDay;

  Map<String, List<Session>> eventsMap = {};
  late List<Session>? eventsList;
  late List<Session> selectedEvents;
  late AnimationController _animationController;
  List<Session> newList = [];

  @override
  void initState() {
    super.initState();

    sessions = widget.sessions;
    //print("Session: $sessions");
    focusedDay = DateTime.now();
    currentDay = DateTime.now();

    // Map sessions for calendar
    mapSessions();

    // Events for today
    selectedEvents = eventsMap[focusedDay] ?? [];
  }

  // Map sessions for calendar
  void mapSessions() {
    print("Session: $sessions");
    for (var session in sessions) {
      String date = "${session.startTime.month}/${session.startTime.day}";
      eventsList = eventsMap[date];
      if (eventsList == null) {
        newList.add(session);
        eventsMap[date] = newList;
        newList = [];
      } else {
        eventsList!.add(session);
      }
    }
    // Don't understand why the map function isn't working
    // sessions.map((session) => {
    //       print("Mapping sessions..."),
    //       selectedEvents = events[session.startTime],
    //       if (selectedEvents == null)
    //         {newList.add(session), events[session.startTime] = newList}
    //       else
    //         {selectedEvents!.add(session)},
    //     });
    print("Events: $eventsMap");
  }

  // Change selected events list
  void onDaySelected(DateTime day, List<Session> events) {
    setState(() {
      selectedEvents = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        TableCalendar(
          focusedDay: focusedDay,
          firstDay: DateTime.utc(2023),
          lastDay: DateTime.utc(2023, 12, 31),
          calendarFormat: _calendarFormat,
          calendarStyle: const CalendarStyle(
            markerDecoration: BoxDecoration(
              color: Colors.orangeAccent,
              shape: BoxShape.circle,
            ),
          ),
          selectedDayPredicate: (day) {
            return isSameDay(currentDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(currentDay, selectedDay)) {
              String date = "${selectedDay.month}/${selectedDay.day}";
              print(date);
              setState(() {
                currentDay = selectedDay;
                this.focusedDay = focusedDay;

                selectedEvents = eventsMap[date] ?? [];
              });
              print(selectedEvents);
            }
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            this.focusedDay = focusedDay;
          },
        ),
        Expanded(
          child: buildEventList(selectedEvents),
        ),
      ],
    );
  }
}

// Event List
Widget buildEventList(List<Session> selectedEvents) {
  return ListView(
    children: selectedEvents
        .map((event) => Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 2.0,
                vertical: 1.0,
              ),
              child: ListTile(
                title: Text(event.id.toString()),
                onTap: () => {
                  print(event.id.toString()),
                },
              ),
            ))
        .toList(),
  );
}

Widget sessionListView(User user, int count, IsarService service) => 
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
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ))));
        }
        else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return SessionCard(session: snapshot.data![index]);
            },
          );
        }
      }
      else {
        return CircularProgressIndicator();
      }
    }
  );

Widget sessionCalendarView() => const Icon(Icons.calendar_month);

class SessionCard extends StatelessWidget {
  final Session session;
  const SessionCard({required this.session, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SessionDetails(session)));
      },
      child: Card(
          elevation: 5,
          color: Colors.orangeAccent,
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          child: ListTile(
                    leading: Text(
                      "${(session.getShotPercentage*100).toStringAsFixed(1)}%", 
                      style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                    title: Text(
                      '${session.startTime.month}/${session.startTime.day}/${session.startTime.year}',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    subtitle: Text(
                      'Total Shots: ${session.getTotalShots}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    trailing: Container(
                      width: 70,
                      height: 70,
                      child: SfCircularChart(
                        series: <CircularSeries>[
                          PieSeries<ChartData, String>(
                            dataSource: [
                              ChartData("Shots Made", session.getTotalMakes.toDouble(), Colors.green),
                              ChartData("Shots Missed", session.getTotalMisses.toDouble(), Colors.red)
                            ],
                            pointColorMapper: (ChartData data, _) => data.color,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                          ),
                        ],
                      ),
                    ),
                  )
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
