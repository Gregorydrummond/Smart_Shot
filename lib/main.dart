import 'package:flutter/material.dart';
import 'session.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.light(),
      // home: Sessions(),
      routes: {
        '/': (context) => Sessions(),
        '/live-session': (context) => Sessions()
      },
    ),
  );
}

class Sessions extends StatefulWidget {
  const Sessions({super.key});

  @override
  State<Sessions> createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  List<Session> sessions = [
    Session(12, 0.25, <int>[2, 1, 1, 2, 1, 0, 1, 1, 2, 1, 1, 1],
        DateTime.utc(2022, 6, 12)),
    Session(12, 0.25, <int>[2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
        DateTime.utc(2022, 6, 14)),
    Session(12, 0.25, <int>[2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
        DateTime.utc(2022, 6, 16)),
    Session(12, 0.25, <int>[2, 1, 1, 2, 1, 1, 1, 0, 2, 1, 1, 1],
        DateTime.utc(2022, 6, 17)),
    Session(12, 0.25, <int>[2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
        DateTime.utc(2022, 6, 12)),
    Session(12, 0.25, <int>[2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
        DateTime.utc(2022, 6, 14)),
    Session(12, 0.25, <int>[2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
        DateTime.utc(2022, 6, 16)),
    Session(12, 0.25, <int>[2, 0, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
        DateTime.utc(2022, 6, 17)),
    Session(12, 0.25, <int>[2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
        DateTime.utc(2022, 6, 12)),
    Session(12, 0.25, <int>[2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
        DateTime.utc(2022, 6, 14)),
    Session(12, 0.25, <int>[2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
        DateTime.utc(2022, 6, 16)),
    Session(12, 0.25, <int>[2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1],
        DateTime.utc(2022, 6, 17)),
  ];

  int index = 0;

  Widget selectPage() {
    switch (index) {
      case 0:
        return SingleChildScrollView(
          child: Column(
              children:
                  sessions.map((session) => SessionCard(session)).toList()),
        );
      case 1:
        return Center(
            heightFactor: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //   const Text('Connect to the shot tracker device via Bluetooth'),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LiveSession()));
                    },
                    child: const Text('Connect'))
              ],
            ));
      case 2:
        return const Text("chart goes here");

      default:
        return SingleChildScrollView(
          child: Column(
              children:
                  sessions.map((session) => SessionCard(session)).toList()),
        );
    }
  }

  void setIndex(int index) {
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text('SMART SHOT',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
      ),
      body: selectPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Sessions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Start Session',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Analyze',
          ),
        ],
        currentIndex: index,
        selectedItemColor: Colors.blue[800],
        onTap: setIndex,
      ),
    );
  }
}

class SessionCard extends StatelessWidget {
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
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.blue,
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
                            color: Colors.blue[900])),
                    const SizedBox(
                      width: 12,
                    ),
                    Text('Shot Percentage: ${session.shotPercentage * 100}%',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900]))
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Text(
                        'Date: ${session.date.month}/${session.date.day}/${session.date.year}',
                        style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[900]))
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
    final List<ChartData> chartData = [
      ChartData('David', 25),
      ChartData('Steve', 38),
      ChartData('Jack', 34),
      ChartData('Others', 52)
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text('Session Details'),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 360,
                  height: 145,
                  //     color: Colors.grey[200],
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.grey[200],
                    // border: Border.all(
                    //   color: Color.fromARGB(198, 28, 50, 113),
                    //   width: 1,
                    // ),
                    //  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),

                  margin: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Date: ${session.date.month}/${session.date.day}/${session.date.year}',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(198, 28, 50, 113))),
                      ]),
                ),
              ),

              Positioned(
                right: 167,
                top: 10,
                child: Container(
                  //   color: Colors.white,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    border: Border.all(
                      color: Color.fromARGB(198, 28, 50, 113),
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),

                  margin: EdgeInsets.all(20),
                  height: 100,
                  width: 160,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(' ${session.totalShots}',
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 12, 21, 96))),
                        Text('Total Shots',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 157, 159, 172))),
                      ]),
                ),
              ),

              Positioned(
                left: 167,
                top: 10,
                child: Container(
                  //   color: Colors.white,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    border: Border.all(
                      color: Color.fromARGB(198, 28, 50, 113),
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),

                  margin: EdgeInsets.all(20),
                  height: 100,
                  width: 160,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(' ${session.shotPercentage * 100}',
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 12, 21, 96))),
                        Text('Shot %',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 157, 159, 172))),
                      ]),
                ),
              ),

              // const Text(
              //   'Shot History',
              //   textAlign: TextAlign.center,
              // ),
              // Column(
              //   children: session.shots.map((shot) {
              //     if (shot == 0) {
              //       return Text('Air Ball');
              //     } else if (shot == 1) {
              //       return Text('Miss');
              //     } else {
              //       return Text('Scored');
              //     }
              //   }).toList(),
              // )
            ],
          ),
          Center(
              child: Container(
                  child: SfCircularChart(series: <CircularSeries>[
            // Render pie chart
            PieSeries<ChartData, String>(
                dataSource: chartData,
                pointColorMapper: (ChartData data, _) => data.color,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y)
          ])))
        ],
      ),
    );
  }
}

// class PieChart extends StatelessWidget {
//   const PieChart({super.key});
//   @override
// Widget build(BuildContext context) {
//   final List<ChartData> chartData = [
//     ChartData('David', 25),
//     ChartData('Steve', 38),
//     ChartData('Jack', 34),
//     ChartData('Others', 52)
//   ];
//     return Scaffold(
//         body: Center(
//             child: Container(
//                 child: SfCircularChart(series: <CircularSeries>[
//       // Render pie chart
//       PieSeries<ChartData, String>(
//           dataSource: chartData,
//           pointColorMapper: (ChartData data, _) => data.color,
//           xValueMapper: (ChartData data, _) => data.x,
//           yValueMapper: (ChartData data, _) => data.y)
//     ]))));
//   }
// }

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}

class LiveSession extends StatefulWidget {
  const LiveSession({super.key});

  @override
  State<LiveSession> createState() => _LiveSessionState();
}

class _LiveSessionState extends State<LiveSession> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text('Live Session'),
      ),
      body: const Text('Camera feed and shot data'),
    );
  }
}
