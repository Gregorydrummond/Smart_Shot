import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:smart_shot/ConnectDevice.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_shot/isar_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'session.dart';
import 'Home.dart';
import 'SessionPage.dart';
import 'CameraSession.dart';
import 'User.dart';
import 'ConnectDevice.dart';
import 'SessionList.dart';
import 'dart:math';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  final dir = await getApplicationSupportDirectory();
  final isar = await Isar.open(
    [SessionSchema],
    directory: dir.path,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of our application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: "Smart Shot",
      // Application theme data
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      // The widget started on application startup
      home: const MainPage(),
    );
  }
}

// Main page of app
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final service = IsarService();
  static final User user = User('Lebron');
  // Indices and corresponding widget/screen for the bottom nav bar
  int currentIndex = 0;
  int count = 0;

  Widget selectPage() {
    List<Widget> screens = [
      Home(user: user),

      //start session page
      SessionPage(user: user, cameras: _cameras, end: endSession),

      // Sessions List page
      SessionList(user: user, service: service)

      //session list page
      // Scaffold(
      //   appBar: AppBar(
      //     title: const Text('Sessions'),
      //     backgroundColor: Colors.orangeAccent,
      //   ),
      //   body: SingleChildScrollView(
      //     child: Column(
      //       children: [
      //         TextButton(
      //             onPressed: () async {
      //               Session session = Session();
      //               session.shotTaken(ShotType.swish);
      //               session.shotTaken(ShotType.miss);
      //               session.shotTaken(ShotType.swish);
      //               session.shotTaken(ShotType.miss);
      //               session.shotTaken(ShotType.bank);
      //               session.shotTaken(ShotType.bank);
      //               session.endSession(user);
      //               session.duration = 10.0;
      //               service.saveSession(session);

      //               List<Session> list = await service.getAllSessions();
      //               setState(() {
      //                 count = list.length;
      //               });
      //             },
      //             child: Text('Add Session')),
      //         Text(count.toString()),
      //         TextButton(
      //             onPressed: () async {
      //               await service.cleanDb();
      //               setState(() {
      //                 count = 0;
      //               });
      //             },
      //             child: Text('Clean DB')),
      //         FutureBuilder<List<Session>>(
      //             future: service.getAllSessions(),
      //             builder: (context, AsyncSnapshot<List<Session>> snapshot) {
      //               if (snapshot.hasData) {
      //                 if (snapshot.data!.isEmpty) {
      //                   return Center(
      //                       child: Container(
      //                           margin: EdgeInsets.only(top: 12.0),
      //                           child: const Text('There are no sessions',
      //                               style: TextStyle(
      //                                   fontSize: 15.0,
      //                                   fontWeight: FontWeight.bold,
      //                                   color: Colors.black))));
      //                 } else {
      //                   return SingleChildScrollView(
      //                     child: Column(
      //                         children: (snapshot.data!)
      //                             .map((session) => SessionCard(session))
      //                             .toList()),
      //                   );
      //                 }
      //               } else {
      //                 return CircularProgressIndicator();
      //               }
      //             })
      //       ],
      //     ),
      //   ),
      // )
    ];

    return screens[currentIndex];
  }

  endSession() {
    setState(() {
      currentIndex = 0;
    });
  }

  // For future use
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selectPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_basketball),
            label: "Live Session",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Sessions",
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

// class SessionCard extends StatelessWidget {
//   final service = IsarService();
//   final Session session;
//   SessionCard(this.session);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => SessionDetails(session)));
//       },
//       child: Card(
//           elevation: 10,
//           color: Colors.orangeAccent,
//           margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//           shape: RoundedRectangleBorder(
//             side: BorderSide(
//               color: Colors.black,
//             ),
//             borderRadius: const BorderRadius.all(Radius.circular(5)),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(5),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Text('Total Shots: ${session.totalShots}',
//                         style: TextStyle(
//                             fontSize: 15.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black)),
//                     const SizedBox(
//                       width: 12,
//                     ),
//                     Text('Shot Percentage: ${session.shotPercentage * 100}%',
//                         style: TextStyle(
//                             fontSize: 15.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black))
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                         'Stats: ${session.getShotPercentage}/${session.getTotalMakes}/${session.getTotalShots}',
//                         style: TextStyle(
//                             fontSize: 10.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black))
//                   ],
//                 )
//               ],
//             ),
//           )),
//     );
//   }
// }

// class SessionDetails extends StatelessWidget {
//   Session session;
//   SessionDetails(this.session, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.orangeAccent,
//         title: const Text('Session Details'),
//       ),
//       body: Column(
//         children: [
//           const Text(
//             'Last Session',
//             style: TextStyle(
//               fontSize: 30,
//             ),
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child:
//                     dataAndLabelBox(session.getShotPercentage * 100, "Shot %"),
//               ),
//               Expanded(
//                 child: dataAndLabelBox(session.getSessionDuration, "Time"),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: dataAndLabelBox(
//                     session.getSwishShots.toDouble(), "Swishes"),
//               ),
//               Expanded(
//                 child: dataAndLabelBox(
//                     session.getTotalMisses.toDouble(), "Misses"),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChartData {
//   ChartData(this.x, this.y, [this.color]);
//   final String x;
//   final double y;
//   final Color? color;
// }
