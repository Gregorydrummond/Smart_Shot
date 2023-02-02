import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Session.dart';
import 'Home.dart';
import 'SessionPage.dart';
import 'CameraSession.dart';
import 'User.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();

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
  static final User user = User('Greg');
  // Indices and corresponding widget/screen for the bottom nav bar
  int currentIndex = 0;
  final screens = [
    Home(
      user: user,
    ),
    SessionPage(user: user),
    CameraSession(cameras: _cameras),
  ];

  // For future use
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
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
            icon: Icon(Icons.camera),
            label: "Tracker",
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
