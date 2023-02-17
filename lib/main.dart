import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
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
  //add isar service
  final service = IsarService();

  static final User user = User('Greg');
  // Indices and corresponding widget/screen for the bottom nav bar
  int currentIndex = 0;
  int count =0;
  Widget selectPage() {
    
    List<Widget> screens = [
      Home(
        user: user,
      ),
      SessionPage(user: user, cameras: _cameras, end: endSession),
      Container(
         child: Column(
          children: [
            TextButton(onPressed: (){
              Session session = Session();
              session.shotTaken(ShotType.make);
              session.shotTaken(ShotType.make);
              session.endSession(user);
              service.saveSession(Session());
             
              }, child: Text('Add Session')),
              TextButton(onPressed: ()async{
              List<Session> list = await  service.getAllSessions();
              
              setState(() {
                count = list.length;
              });
              }, child : Text('Get Sessions')),

              Text(count.toString()) 
          ],
        ),
      )
    ];

    return screens[currentIndex];
  }

  // child: Column(
  //         children: [
  //           TextButton(onPressed: (){
  //             Session session = Session();
  //             session.shotTaken(ShotType.make);
  //             session.shotTaken(ShotType.make);
  //             session.endSession(user);
  //             service.saveSession(Session());
             
  //             }, child: Text('Add Session')),
  //             TextButton(onPressed: ()async{
  //             List<Session> list = await  service.getAllSessions();
              
  //             setState(() {
  //               count = list.length;
  //             });
  //             }, child : Text('Get Sessions')),

  //             Text(count.toString()) 
  //         ],
  //       ),

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
