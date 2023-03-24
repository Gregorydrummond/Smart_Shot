import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  static User user = User(null);
  late SharedPreferences prefs;
  // Indices and corresponding widget/screen for the bottom nav bar
  int currentIndex = 0;
  int count = 0;
  List<Session> sessions = [];

  Widget selectPage() {
    List<Widget> screens = [
      Home(user: user),
      SessionPage(cameras: _cameras, end: endSession),
      SessionList(
        service: service,
        sessions: sessions,
        count: count,
      ),
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
    initUser();
  }

  void initSessions() async {
    sessions = await service.getAllSessions();
  }

  void initUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String? name = prefs.getString('name');
      if (name != null) {
        user = User(name);
      }
      else {
        user = User("");
      }
    });
  }

  void createUser(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    setState(() {
      user = User(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user.name == '') {
      TextEditingController controller = TextEditingController();
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Please Provide a Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                  child: TextField(
                    controller: controller,
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    elevation: MaterialStatePropertyAll<double>(3.0),
                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.orangeAccent)
                  ),
                  onPressed: () {
                    setState(() {
                      if (controller.value.text.trim() != '') {
                        createUser(controller.value.text);
                      }
                    });
                  },
                  child: Text('Submit', style: TextStyle(color: Colors.black, fontSize: 20),)
                )
              ],
            ),
          ),
        ),
      );
    }
    else if (user.name == null) {
      return Scaffold(
        body: Center(
          child: Icon(Icons.sports_basketball, size: 100, color: Colors.orangeAccent,),
        ),
      );
    }
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
            initSessions();
          });
        },
      ),
    );
  }
}
