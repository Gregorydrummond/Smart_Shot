import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:async';

class ConnectDevice extends StatefulWidget {
  // State management
  ConnectDevice({super.key, required this.onConnection});
  static bool _foundDeviceWaitingToConnect = false;
  static bool _scanStarted = false;
  static bool connected = false;

  // Bluetooth
  static late DiscoveredDevice smartShotDevice;
  static final flutterReactiveBLE = FlutterReactiveBle();
  static final ReactiveBlePlatform flutterReactiveBLEPlatform =
      ReactiveBlePlatform.instance;
  static late StreamSubscription<DiscoveredDevice> _scanStream;
  static late StreamSubscription<ConnectionStateUpdate> _connectionStream;
  static late List<DiscoveredService> _discoveredServices;
  static late QualifiedCharacteristic randomQualifiedCharacteristic;
  static late DiscoveredCharacteristic randomDiscoveredCharacteristic;

  // Functions
  Function onConnection;

  @override
  State<ConnectDevice> createState() => _ConnectDeviceState();
}

class _ConnectDeviceState extends State<ConnectDevice> {
  // Service and characteristics that we care about
  static final Uuid serviceUuid =
      Uuid.parse('0000180a-0000-1000-8000-00805f9b34fb');
  static final Uuid randomCharacteristicUuid =
      Uuid.parse('00002a58-0000-1000-8000-00805f9b34fb');
  static final Uuid switchCharacteristicUuid =
      Uuid.parse('00002a57-0000-1000-8000-00805f9b34fb');

  static const int TIMEOUT_DURATION = 7500;
  static bool scanRestarted = false;
  static bool connectRestarted = false;

  void restartScan(bool scanRestart) {
    setState(() {
      scanRestarted = scanRestart;
    });
  }

  void restartConnect(bool connectRestart) {
    setState(() {
      connectRestarted = connectRestart;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  // Dialogs
  Future showAlertDialog(String title, String content) {
    print("Showing alert");
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (ConnectDevice._scanStarted) {
                    restartScan(false);
                  } else {
                    restartConnect(false);
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  if (ConnectDevice._scanStarted) {
                    restartScan(true);
                  } else {
                    restartConnect(true);
                  }

                  Navigator.of(context).pop();
                },
                child: const Text('Yes'),
              ),
            ],
          );
        });
  }

  // Start a scan for peripheral devices
  void _startScan() async {
    // Loading indicator
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Platform permissions handling stuff
    bool permGranted = false;
    // State management
    setState(() {
      ConnectDevice._scanStarted = true;
    });
    if (Platform.isAndroid) {
      if (await Permission.location.request().isGranted && await Permission.bluetoothConnect.request().isGranted && await Permission.bluetoothScan.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        permGranted = true;
      }
    } else if (Platform.isIOS) {
      permGranted = true;
    }

    if (permGranted) {
      ConnectDevice._scanStarted = true;
      print("Scan started");

      // Start Stopwatch
      Stopwatch stopwatch = Stopwatch();
      int elaspedTime;
      stopwatch.start();

      ConnectDevice._scanStream = ConnectDevice.flutterReactiveBLE
          .scanForDevices(withServices: []).listen((device) async {
        print("listening");

        elaspedTime = stopwatch.elapsedMilliseconds;
        print(elaspedTime);

        // Timeout
        if ((elaspedTime >= TIMEOUT_DURATION) & stopwatch.isRunning) {
          // Stop stopwatch
          stopwatch.stop();

          // Pause stream
          ConnectDevice._scanStream.pause();
          //ConnectDevice._scanStarted = false;

          await showAlertDialog('Scan Failed',
              'SmartShot device not found. Do you want to continue scanning?');

          if (scanRestarted) {
            print("Restarting scan");
            // Restart stopwatch
            stopwatch.reset();
            stopwatch.start();
            ConnectDevice._scanStream.resume();
            //ConnectDevice._scanStarted = false;
          } else {
            print("Stopping scan");
            ConnectDevice._scanStream.cancel();
            ConnectDevice._scanStarted = false;
            // Go back to the home screen
            Navigator.of(context).pop();
            // Navigator.of(context).pop();
            widget.onConnection(message: "SmartShot device not found");
          }
        }

        if (device.name == 'SmartShot') {
          setState(() {
            ConnectDevice.smartShotDevice = device;
            ConnectDevice._scanStarted = false;
            ConnectDevice._foundDeviceWaitingToConnect = true;

            // Stop scanning
            ConnectDevice._scanStream.cancel();
            print("Scanning is done");

            // Stop stopwatch when device is found
            stopwatch.stop();

            _connectToDevice();
          });
        }
      });
    }
  }

  // Connect to device
  void _connectToDevice() {
// Start Stopwatch
    Stopwatch stopwatch = Stopwatch();
    int elaspedTime;
    stopwatch.start();

    // Connect to Smart Shot device. Method returns a stream to listen to connection state
    ConnectDevice._connectionStream = ConnectDevice.flutterReactiveBLE
        .connectToDevice(
      id: ConnectDevice.smartShotDevice.id,
      connectionTimeout: const Duration(seconds: 5),
    )
        .listen((event) async {
      switch (event.connectionState) {
        case DeviceConnectionState.connected:
          {
            // Connected to device
            ConnectDevice._discoveredServices = await ConnectDevice
                .flutterReactiveBLE
                .discoverServices(ConnectDevice.smartShotDevice.id);
            for (var service in ConnectDevice._discoveredServices) {
              for (var characteristic in service.characteristics) {
                if (characteristic.characteristicId ==
                    randomCharacteristicUuid) {
                  ConnectDevice.randomDiscoveredCharacteristic = characteristic;
                  ConnectDevice.randomQualifiedCharacteristic =
                      QualifiedCharacteristic(
                    characteristicId: randomCharacteristicUuid,
                    serviceId: serviceUuid,
                    deviceId: ConnectDevice.smartShotDevice.id,
                  );
                  break;
                }
              }
            }

            // Switched the order of these (return if it looks weird)
            // Pop the loading animation and the connect to device screen
            Navigator.of(context).pop();
            // Navigator.of(context).pop();

            setState(() {
              ConnectDevice._foundDeviceWaitingToConnect = false;
              ConnectDevice.connected = true;
              widget.onConnection(message: "SmartShot Device Connected!");
            });

            break;
          }
        case DeviceConnectionState.connecting:
          {
            print('Connecting...');

            elaspedTime = stopwatch.elapsedMilliseconds;
            print(elaspedTime);

            // Timeout
            if ((elaspedTime >= TIMEOUT_DURATION) & stopwatch.isRunning) {
              // Stop stopwatch
              stopwatch.stop();

              // Pause the stream
              ConnectDevice._connectionStream.pause();

              await showAlertDialog('Connection Failed',
                  'SmartShot device not connected. Do you want to try again?');

              if (connectRestarted) {
                print("Reattempting to connect");
                // Restart stopwatch
                stopwatch.reset();
                stopwatch.start();
                ConnectDevice._connectionStream.resume();
              } else {
                print("Stopping connection");
                ConnectDevice._connectionStream.cancel();
                // Go back to the home screen
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                widget.onConnection(message: "Connection failed");
              }
            }
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

  // Widget to start the scan
  Widget startScan() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: () {
                  _startScan();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'Connect to SmartShot Device',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return startScan();
  }
}
