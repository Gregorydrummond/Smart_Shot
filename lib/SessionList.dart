import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:smart_shot/isar_service.dart';
import 'Home.dart';
import 'session.dart';
import 'User.dart';

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

class _SessionListState extends State<SessionList> {
  int count = 0;
  final int TAB_COUNT = 2;
  List<Session> sessions = [];

  void update(List<Session> sessions, int newCount) {
    setState(() {
      this.sessions = sessions;
      count = newCount;
    });
  }

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
                  sessionListView(widget.user, count, widget.service, update),
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

  final service = IsarService();
  late Future<List<Session>> sessionList; // = [] as Future<List<Session>>;
  ListView listView = ListView();

  @override
  void initState() {
    super.initState();

    //sessions = widget.sessions;
    //print("Session: $sessions");
    focusedDay = DateTime.now();
    currentDay = DateTime.now();

    // Map sessions for calendar
    //mapSessions();

    // Events for today
    selectedEvents = eventsMap[focusedDay] ?? [];
  }

  // Map sessions for calendar
  void mapSessions(List<Session> sessions) async {
    // Query sessions for the month
    // sessionList = service.getSessionsWithinDates(
    //     DateTime.utc(focusedDay.year, focusedDay.month, 1),
    //     DateTime(focusedDay.year, (focusedDay.month + 1 % 13))
    //         .subtract(const Duration(days: 1)));

    // sessions = await sessionList;

    //listView = buildEventList(selectedEvents) as ListView;

    print("Session: $sessions");
    // Put year in key
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
    // selectedEvents = eventsMap.isNotEmpty ? eventsMap.entries.last.value : [];

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

  // // Event List (Future builder??)
  // Widget buildEventList(List<Session> selectedEvents) {
  //   return FutureBuilder(
  //       future: sessionList,
  //       builder: (context, AsyncSnapshot<List<Session>> snapshot) {
  //         if (snapshot.hasData) {
  //           return ListView(
  //             children: snapshot.data!
  //                 .map((event) => Container(
  //                       decoration: BoxDecoration(
  //                         color: Colors.orangeAccent,
  //                         border: Border.all(width: 0.5),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       margin: const EdgeInsets.symmetric(
  //                         horizontal: 2.0,
  //                         vertical: 1.0,
  //                       ),
  //                       child: ListTile(
  //                         title: Text(event.id.toString()),
  //                         onTap: () => {
  //                           print(event.id.toString()),
  //                         },
  //                       ),
  //                     ))
  //                 .toList(),
  //           );
  //         } else {
  //           return Container();
  //         }
  //       });
  // }

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
            setState(() {
              this.focusedDay = focusedDay;
              // eventsMap = {};
              // mapSessions();

              // selectedEvents =
              //     eventsMap.isNotEmpty ? eventsMap.entries.last.value : [];
              //print("Selected Events: $selectedEvents");
              //listView = buildEventList(selectedEvents) as ListView;
            });

            print("Day: ${this.focusedDay}");
          },
        ),
        Expanded(
          child: buildEventList(),
          // Set selected events
          // child: buildEventList(selectedEvents),
        ),
      ],
    );
  }

  // Event List (Future builder??)
  Widget buildEventList() {
    return FutureBuilder<List<Session>>(
        future: service.getSessionsWithinDates(
            DateTime.utc(focusedDay.year, focusedDay.month, 1),
            DateTime(focusedDay.year, (focusedDay.month + 1 % 13))),
        builder: (context, AsyncSnapshot<List<Session>> snapshot) {
          if (snapshot.hasData) {
            eventsMap = {};
            mapSessions(snapshot.data!);
            // Get the last day in the event map
            print("Selected Events: $selectedEvents");
            return ListView(
              children: selectedEvents
                  .map((session) => Container(
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
                          title: Text(session.id.toString()),
                          onTap: () => {
                            print(session.id.toString()),
                          },
                        ),
                      ))
                  .toList(),
            );
          } else {
            return Container();
          }
        });
  }
}

// // Event List (Future builder??)
// Widget buildEventList(List<Session> selectedEvents) {
//   return ListView(
//     children: selectedEvents
//         .map((event) => Container(
//               decoration: BoxDecoration(
//                 color: Colors.orangeAccent,
//                 border: Border.all(width: 0.5),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               margin: const EdgeInsets.symmetric(
//                 horizontal: 2.0,
//                 vertical: 1.0,
//               ),
//               child: ListTile(
//                 title: Text(event.id.toString()),
//                 onTap: () => {
//                   print(event.id.toString()),
//                 },
//               ),
//             ))
//         .toList(),
//   );
// }

Widget sessionListView(
        User user, int count, IsarService service, Function update) =>
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

                List<Session> list = await service.getAllSessions();
                update(list, list.length);
              },
              child: Text('Add Session')),
          Text(count.toString()),
          TextButton(
              onPressed: () async {
                await service.cleanDb();
                List<Session> emptyList = [];
                update(emptyList, 0);
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
