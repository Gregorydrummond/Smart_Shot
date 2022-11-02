import 'package:flutter/material.dart';
import 'session.dart';

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
              children: [
                const Text('Connect to the shot tracker device via Bluetooth'),
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
        return Center(
          heightFactor: 20,
          child: const Text('Graph to display shot progress'),
        );
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
        backgroundColor: Colors.amber[800],
        title: const Text('Smart Shot'),
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
        selectedItemColor: Colors.amber[800],
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
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Total Shots: ${session.totalShots}'),
                    const SizedBox(
                      width: 12,
                    ),
                    Text('Shot Percentage: ${session.shotPercentage * 100}%')
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Text(
                        'Date: ${session.date.month}/${session.date.day}/${session.date.year}')
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
  SessionDetails(this.session);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[800],
        title: const Text('Session Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              'Date: ${session.date.month}/${session.date.day}/${session.date.year}'),
          const SizedBox(
            height: 16,
          ),
          Text('Total Shots: ${session.totalShots}'),
          const SizedBox(
            height: 16,
          ),
          Text('Shot Percentage: ${session.shotPercentage}'),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Shot History',
            textAlign: TextAlign.center,
          ),
          Column(
            children: session.shots.map((shot) {
              if (shot == 0) {
                return Text('Air Ball');
              } else if (shot == 1) {
                return Text('Miss');
              } else {
                return Text('Scored');
              }
            }).toList(),
          )
        ],
      ),
    );
  }
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
        backgroundColor: Colors.amber[800],
        title: const Text('Live Session'),
      ),
      body: const Text('Camera feed and shot data'),
    );
  }
}
