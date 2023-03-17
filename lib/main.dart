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

class CamTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CamTestState();
}

class _CamTestState extends State<CamTest> {
  int airballs = 0;
  late Timer timer;

  void ballDetected() {
    timer = Timer(Duration(seconds: 4), () {
      setState(() {
        airballs += 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CameraSession(cameras: _cameras, ballDetected: ballDetected),
          Text("Airballs: $airballs"),
          TextButton(onPressed: () {
            timer.cancel();
          }, child: const Text('Cancel Timer'))
        ],
      ),
    );
  }
}

class _MainPageState extends State<MainPage> {
  final service = IsarService();
  static final User user = User('Lebron');
  // Indices and corresponding widget/screen for the bottom nav bar
  int currentIndex = 0;
  int count = 0;
  List<Session> sessions = [];

  Widget selectPage() {
    List<Widget> screens = [
      Home(user: user),

      //start session page
      SessionPage(user: user, cameras: _cameras, end: endSession),

      // Sessions List page
      SessionList(
        user: user,
        service: service,
        sessions: sessions,
        count: count,
      ),
      CamTest()
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

    initSessions();
  }

  void initSessions() async {
    sessions = await service.getAllSessions().then((sessions) {
      setState(() {
        this.sessions = sessions;
        count = this.sessions.length;
      });

      throw Error();
    });
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
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Test",
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
            initSessions();
          });
        },
      ),
    );
  }
}
