import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_shot/CameraSession.dart';
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

  @override
  void initState() {
    super.initState();
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
            CameraSession(cameras: widget.cameras),
            Row(
              children: [
                Expanded(
                  child:
                      _buildDataBox("${session.getTotalMakes}", "Shots made"),
                ),
                Expanded(
                  child:
                      _buildDataBox("${session.getTotalShots}", "Total Shots"),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildDataBox(
                      "${session.getTotalMisses}", "Shots missed"),
                ),
                Expanded(
                  child:
                      _buildDataBox("${session.getShotPercentage}%", "Shot %"),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildDataBox("0m", "Time"),
                ),
                Expanded(
                  child: _buildDataBox("0", "Current Streak"),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    sessionStarted = false;
                    unsubscribeFromCharacteristic();
                    endSession();
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

  // Unsubscribe from random characteristic
  void unsubscribeFromCharacteristic() {
    ConnectDevice.flutterReactiveBLEPlatform.stopSubscribingToNotifications(
        ConnectDevice.randomQualifiedCharacteristic);
  }

  // Create new session
  void startNewSession() {
    session = Session();
  }

  // End session
  void endSession() {
    session.endSession(widget.user);
    service.saveSession(session);
    widget.user.sessions.add(session);
    print(widget.user.totalShots);
    widget.end();
  }

  // Override dispose function

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

// Function to build those orange boxes
Widget _buildDataBox(String shotData, String dataLabel) => Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      height: 150,
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        border: Border.all(
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              shotData,
              style: const TextStyle(
                fontSize: 70,
              ),
            ),
          ),
          Expanded(
            child: Text(
              dataLabel,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
