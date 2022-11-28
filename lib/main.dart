import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'session.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();

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
        return const CameraSession();
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
  // State management
  bool _foundDeviceWaitingToConnect = false;
  bool _scanStarted = false;
  bool _connected = false;

  // Data
  static int value = 4;

  // Bluetooth
  late DiscoveredDevice smartShotDevice;
  final flutterReactiveBLE = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> _scanStream;
  late List<DiscoveredService> _discoveredServices;
  late QualifiedCharacteristic randomQualifiedCharacteristic;
  late DiscoveredCharacteristic randomDiscoveredCharacteristic;

  // Service and characteristics that we care about
  final Uuid serviceUuid = Uuid.parse('0000180a-0000-1000-8000-00805f9b34fb');
  final Uuid randomCharacteristicUuid =
      Uuid.parse('00002a58-0000-1000-8000-00805f9b34fb');
  final Uuid switchCharacteristicUuid =
      Uuid.parse('00002a57-0000-1000-8000-00805f9b34fb');

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
    Stream<ConnectionStateUpdate> _currentConnectionStatus =
        flutterReactiveBLE.connectToDevice(
      id: smartShotDevice.id,
      connectionTimeout: const Duration(seconds: 5),
    );

    _currentConnectionStatus.listen((event) async {
      switch (event.connectionState) {
        case DeviceConnectionState.connected:
          {
            // Connected to device
            _discoveredServices =
                await flutterReactiveBLE.discoverServices(smartShotDevice.id);
            for (var service in _discoveredServices) {
              for (var characteristic in service.characteristics) {
                if (characteristic.characteristicId ==
                    randomCharacteristicUuid) {
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
        case DeviceConnectionState.connecting:
          {
            print('Connecting...');
            break;
          }
        case DeviceConnectionState.disconnected:
          {
            print('Disconnected');
            break;
          }
        case DeviceConnectionState.disconnecting:
          {
            print('Disconnecting...');
          }
      }
    });
  }

  void _subToCharacteristic() {
    flutterReactiveBLE
        .subscribeToCharacteristic(randomQualifiedCharacteristic)
        .listen((data) {
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
    var shot = "";
    switch (value) {
      case 0:
        shot = "Miss";
        break;
      case 1:
        shot = "Point Made";
        break;
      case 3:
        shot = "Swish";
        break;
      default:
        shot = "Waiting";
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text('Live Session'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              width: 200,
              height: 200,
              color: Colors.orange,
              alignment: Alignment.center,
              child: Text(
                shot,
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

class CameraSession extends StatefulWidget {
  const CameraSession({super.key});

  @override
  State<CameraSession> createState() => _CameraSessionState();
}

class _CameraSessionState extends State<CameraSession> {
  static const platform = MethodChannel('smartshot/opencv');

  late CameraController controller;
  // late Future<void> _initializeControllerFuture;

  bool showCameraPreview = true;

  late String imagePath;

  Future<void> _processImage({required String path}) async {
    try {
      String returnPath =
          await platform.invokeMethod('processImage', {"path": path});
      print(returnPath);
      setState(() {
        imagePath = path;
        showCameraPreview = false;
      });
    } on PlatformException catch (e) {
      print(e);
      return;
    }
  }

  Future<void> _takePicture() async {
    try {
      final image = await controller.takePicture();
      if (!mounted) return;
      await _processImage(path: image.path);
    } catch (e) {
      print(e);
    }
  }

  void _returnToPreview() {
    setState(() {
      showCameraPreview = true;
    });
  }

  Widget _pickBody() {
    if (showCameraPreview == true) {
      return CameraPreview(controller);
    } else {
      return Image.file(File(imagePath));
    }
  }

  Widget _pickFloatingAction() {
    if (showCameraPreview == true) {
      return FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.add_a_photo),
      );
    } else {
      return FloatingActionButton(
        onPressed: _returnToPreview,
        tooltip: 'Return To Preview',
        child: const Icon(Icons.arrow_back_rounded),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pickBody(),
      floatingActionButton: _pickFloatingAction(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
