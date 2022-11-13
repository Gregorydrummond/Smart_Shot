import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'session.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

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
        return const Center(
          heightFactor: 20,
          child: Text('Graph to display shot progress'),
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

  // State management
  bool _foundDeviceWaitingToConnect = false;
  bool _scanStarted = false;
  bool _connected = false;

  // Data
  static int value = 2;

  // Bluetooth
  late DiscoveredDevice smartShotDevice;
  final flutterReactiveBLE = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> _scanStream;
  late List<DiscoveredService> _discoveredServices;
  late QualifiedCharacteristic randomQualifiedCharacteristic;
  late DiscoveredCharacteristic randomDiscoveredCharacteristic;

  // Service and characteristics that we care about
  final Uuid serviceUuid = Uuid.parse('0000180a-0000-1000-8000-00805f9b34fb');
  final Uuid randomCharacteristicUuid = Uuid.parse('00002a58-0000-1000-8000-00805f9b34fb');
  final Uuid switchCharacteristicUuid = Uuid.parse('00002a57-0000-1000-8000-00805f9b34fb');

  @override
  void initState() {
    super.initState();

    _startScan();
  }

  // Start a scan for peripheral devices
  void _startScan() async {
    // Platform permissions handling stuff
    bool permGranted = false;
    setState(() {
      _scanStarted = true;
    });
    if (Platform.isAndroid) {
      if (await Permission.location.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        permGranted = true;
      }
    } else if (Platform.isIOS) {
      permGranted = true;
    }

    if (permGranted) {
      _scanStream =
          flutterReactiveBLE.scanForDevices(withServices: []).listen((device) {
            if (device.name == 'SmartShot') {
              setState(() {
                smartShotDevice = device;
                _foundDeviceWaitingToConnect = true;
                _connectToDevice();
                //print('Found device for real: ${device.name}');
              });
            }
          });
    }
  }

  void _connectToDevice() {
    // Stop scanning
    _scanStream.cancel();

    // Connect to Smart Shot device. Method returns a stream to listen to connection state
    Stream<ConnectionStateUpdate> _currentConnectionStatus = flutterReactiveBLE.connectToDevice(
      id: smartShotDevice.id,
      connectionTimeout: const Duration(seconds: 5),
    );

    _currentConnectionStatus.listen((event) async {
      switch (event.connectionState) {
        case DeviceConnectionState.connected: {     // Connected to device
          _discoveredServices = await flutterReactiveBLE.discoverServices(smartShotDevice.id);
          for (var service in _discoveredServices) {
            for (var characteristic in service.characteristics) {
              if (characteristic.characteristicId == randomCharacteristicUuid) {
                randomDiscoveredCharacteristic = characteristic;
                randomQualifiedCharacteristic = QualifiedCharacteristic(
                  characteristicId: randomCharacteristicUuid,
                  serviceId: serviceUuid,
                  deviceId: smartShotDevice.id,
                );
                break;
              }
            }
          }
          setState(() {
            _foundDeviceWaitingToConnect = false;
            _connected = true;
            _subToCharacteristic();
          });
          break;
        }
        case DeviceConnectionState.connecting: {
          print('Connecting...');
          break;
        }
        case DeviceConnectionState.disconnected: {
          print('Disconnected');
          break;
        }
        case DeviceConnectionState.disconnecting: {
          print('Disconnecting...');
        }
      }
    });
  }

  void _subToCharacteristic() {
    flutterReactiveBLE.subscribeToCharacteristic(randomQualifiedCharacteristic).listen((data) {
      //print(data);
      setState(() {
        value = data.isNotEmpty ? data.first : 2;
        //print(value);
      });
    }, onError: (dynamic error) {
      print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[800],
        title: const Text('Live Session'),
      ),
      body: Center(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              width: 200,
              height: 200,
              color: Colors.orange,
              alignment: Alignment.center,
              child:
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 50,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              width: 200,
              height: 200,
              color: Colors.green,
              alignment: Alignment.center,
              child: const Text(
                'Turn On',
                style: TextStyle(
                  fontSize: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
