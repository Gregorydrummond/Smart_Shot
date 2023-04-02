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
  late IsarService service;
  late List<Session> sessions;
  late int count;
  SessionList(
      {super.key,
      required this.service,
      required this.sessions,
      required this.count});

  @override
  State<SessionList> createState() => _SessionListState();
}

class _SessionListState extends State<SessionList>
    with SingleTickerProviderStateMixin {
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
                title: const Text(
                  'Sessions',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.orangeAccent,
                bottom: const TabBar(
                  tabs: [
                    Tab(
                        icon: Icon(
                      Icons.list,
                      color: Colors.black,
                    )),
                    Tab(
                        icon: Icon(
                      Icons.calendar_month,
                      color: Colors.black,
                    )),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  sessionListView(count, widget.service),
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
  late DateTime focusedDay;
  late DateTime currentDay;
  late DateTime selectedDay;

  Map<String, List<Session>> eventsMap = {};
  Map<DateTime, List<Session>> _sessionEventsMap = {};
  late List<Session> eventsList;
  late List<Session> eventList2;
  List<Session> selectedEvents = [];
  late AnimationController _animationController;
  List<Session> newList = [];

  final service = IsarService();
  //late Future<List<Session>> sessionList;
  List<Session> sessionList = [];
  ListView listView = ListView();

  @override
  void initState() {
    super.initState();

    focusedDay = DateTime.now();
    selectedDay = DateTime.now();
    currentDay = DateTime.now();

    // Events for today
    selectedEvents = eventsMap[focusedDay] ?? [];

    // Get sessions for the month
    _fetchSessions();
  }

  // Get data for the focused month
  Future _fetchSessions() async {
    List<Session> monthlySessions = [];
    monthlySessions = await service.getSessionsWithinDates(
        DateTime.utc(focusedDay.year, focusedDay.month, 1),
        DateTime(focusedDay.year, (focusedDay.month + 1 % 13)));

    setState(() {
      sessionList = monthlySessions;
    });

    // Map sessions with date as key
    mapSessions(sessionList);
  }

  // Map sessions for calendar
  void mapSessions(List<Session> sessions) async {
    print("Session: $sessions");
    _sessionEventsMap = {};
    // Put day as key
    for (var session in sessions) {
      DateTime date = DateTime.utc(session.startTime.year,
          session.startTime.month, session.startTime.day, 0);
      eventsList = _sessionEventsMap[date] ?? [];
      if (eventsList.isEmpty) {
        eventsList.add(session);
        _sessionEventsMap[date] = eventsList;
      } else {
        _sessionEventsMap[date]!.add(session);
      }
    }

    print("Events: $_sessionEventsMap");

    // Select events to be shown as a table
    // Get selected date
    DateTime selectedDayDate =
        DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day, 0);
    eventsList = _sessionEventsMap[selectedDay] ?? [];

    if (eventsList.isEmpty) {
      // If page changed (focused day month will be different than selected day month) => eventList == null. Change selected day to last day in eventsMap if it's not empty
      if (focusedDay.month != selectedDay.month) {
        if (_sessionEventsMap.isNotEmpty) {
          // Session exists for that month
          selectedDay = _sessionEventsMap
              .entries.last.value.first.startTime; // DateTime of last session
          selectedDayDate = DateTime.utc(
              selectedDay.year,
              selectedDay.month,
              selectedDay.day,
              0); // DateTime of last session reformatted to use as a key
          eventsList = _sessionEventsMap[selectedDayDate]!;
          onDaySelected(eventsList);
        } else {
          onDaySelected([]);
        }
      } else {
        onDaySelected([]);
      }
    } else {
      onDaySelected(eventsList);
    }
  }

// Change selected events list
  void onDaySelected(List<Session> events) {
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
          eventLoader: (date) {
            return _sessionEventsMap[date] ?? [];
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              return null;
            },
          ),
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
              setState(() {
                currentDay = selectedDay;
                this.focusedDay = focusedDay;
                this.selectedDay = selectedDay;
              });

              DateTime selectedDayDate = DateTime.utc(
                  selectedDay.year, selectedDay.month, selectedDay.day, 0);
              eventsList = _sessionEventsMap[selectedDayDate] ?? [];
              onDaySelected(eventsList);
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
            setState(() {
              this.focusedDay = focusedDay;
            });

            _fetchSessions();
          },
        ),
        Expanded(
            child: ListView.builder(
                itemCount: selectedEvents.length,
                itemBuilder: (context, index) {
                  return SessionCard(session: selectedEvents[index]);
                })),
      ],
    );
  }
}

Widget sessionListView(int count, IsarService service) =>
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
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return SessionCard(session: snapshot.data![index]);
                },
              );
            }
          } else {
            return CircularProgressIndicator();
          }
        });

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
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: ListTile(
            leading: Text(
              "${(session.getShotPercentage * 100).toStringAsFixed(1)}%",
              style:
                  const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
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
                      ChartData("Shots Made", session.getTotalMakes.toDouble(),
                          Colors.green),
                      ChartData("Shots Missed",
                          session.getTotalMisses.toDouble(), Colors.red)
                    ],
                    pointColorMapper: (ChartData data, _) => data.color,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
