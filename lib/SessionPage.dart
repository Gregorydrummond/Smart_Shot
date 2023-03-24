import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_shot/CameraSession.dart';
import 'package:smart_shot/StatCard.dart';
import 'package:smart_shot/isar_service.dart';
import 'dart:io';
import 'dart:async';
import 'ConnectDevice.dart';
import 'session.dart';
import 'User.dart';
import 'Home.dart';

class SessionPage extends StatefulWidget {
  late User user;
  final List<CameraDescription> cameras;
  Function end;

  SessionPage(
      {super.key,
      required this.user,
      required this.cameras,
      required this.end});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  late Session session;
  bool sessionStarted = false;
  GlobalKey camKey = GlobalKey();
  final service = IsarService();

  // Data
  int shot = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    session.endSession(widget.user);
    widget.user.sessions.add(session);
    await service.saveSession(session);
    await unsubscribeFromCharacteristic();
  }

  // Widget to start the session
  Widget startSessionScreen() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    sessionStarted = true;
                    startNewSession();
                    _subToCharacteristic();
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'Start SmartShot Session',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

// Widget for live data
  Widget liveFeedScreen() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CameraSession(cameras: widget.cameras, ballDetected: ballDetected,),
            Row(
              children: [
                Expanded(
                  child: StatCard(value: session.getTotalMakes.toDouble(), title: "Shots made", type: "count",),
                ),
                Expanded(
                  child: StatCard(value: session.getTotalShots.toDouble(), title: "Total Shots", type: "count"),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: StatCard(value: session.getTotalMisses.toDouble(), title: "Shots missed", type: "count"),
                ),
                Expanded(
                  child: StatCard(value: session.getShotPercentage, title: "Shot %", type: "percent"),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: StatCard(value: session.getAirballShots.toDouble(), title: "Airballs", type: "count",),
                ),
                Expanded(
                  child: StatCard(value: 0.0, title: "Current Streak", type: "count",),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    sessionStarted = false;
                    widget.end();
                    // unsubscribeFromCharacteristic();
                    // endSession();
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'End Session',
                  style: TextStyle(
                    fontSize: 45,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  // Listen for the random characteristic
  void _subToCharacteristic() {
    ConnectDevice.flutterReactiveBLE
        .subscribeToCharacteristic(ConnectDevice.randomQualifiedCharacteristic)
        .listen((data) {
      //print(data);
      setState(() {
        shot = data.isNotEmpty ? data.first : -1;
        if (shot != -1) {
          try {
            timer.cancel();
          } catch (e) {}
        }
        switch (shot) {
          case 0:
            print("Shot misses");
            session.shotTaken(ShotType.miss);
            break;
          case 1:
            print("Swish made");
            session.shotTaken(ShotType.swish);
            break;

          case 2:
            print("Bank made");
            session.shotTaken(ShotType.bank);
            break;
          default:
        }
      });
    }, onError: (dynamic error) {
      print('Error: $error');
    });
  }

  // Listen for the airball from the camera
  void ballDetected() {
    timer = Timer(Duration(seconds: 5), () {
      setState(() {
        print("Airball!!");
        session.shotTaken(ShotType.airball);
      });
    });
  }

  // Unsubscribe from random characteristic
  Future<void> unsubscribeFromCharacteristic() async {
    ConnectDevice.flutterReactiveBLEPlatform.stopSubscribingToNotifications(
        ConnectDevice.randomQualifiedCharacteristic);
  }

  // Create new session
  void startNewSession() {
    session = Session();
  }

  // End session
  Future<void> endSession() async {
    session.endSession(widget.user);
    service.saveSession(session);
    widget.user.sessions.add(session);
    widget.end();
  }

  // Return the start session or the live session screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The title text which will be shown on the action bar
        title: const Text('Live Session'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: sessionStarted ? liveFeedScreen() : startSessionScreen(),
    );
  }
}
