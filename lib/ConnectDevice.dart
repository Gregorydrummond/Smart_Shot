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
  static bool _connected = false;
  static bool _connectedBefore = false;

  // Bluetooth
  static late DiscoveredDevice smartShotDevice;
  static final flutterReactiveBLE = FlutterReactiveBle();
  static final ReactiveBlePlatform flutterReactiveBLEPlatform =
      ReactiveBlePlatform.instance;
  static late StreamSubscription<DiscoveredDevice> _scanStream;
  static late List<DiscoveredService> _discoveredServices;
  static late QualifiedCharacteristic randomQualifiedCharacteristic;
  static late DiscoveredCharacteristic randomDiscoveredCharacteristic;

  // Functions
  Function onConnection;

  @override
  State<ConnectDevice> createState() => _ConnectDeviceState();

  static bool get connectedBefore {
    return ConnectDevice._connectedBefore;
  }
}

class _ConnectDeviceState extends State<ConnectDevice> {
  // Service and characteristics that we care about
  static final Uuid serviceUuid =
      Uuid.parse('0000180a-0000-1000-8000-00805f9b34fb');
  static final Uuid randomCharacteristicUuid =
      Uuid.parse('00002a58-0000-1000-8000-00805f9b34fb');
  static final Uuid switchCharacteristicUuid =
      Uuid.parse('00002a57-0000-1000-8000-00805f9b34fb');

  @override
  void initState() {
    super.initState();
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
      if (await Permission.location.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        permGranted = true;
      }
    } else if (Platform.isIOS) {
      permGranted = true;
    }

    if (permGranted) {
      ConnectDevice._scanStream = ConnectDevice.flutterReactiveBLE
          .scanForDevices(withServices: []).listen((device) {
        if (device.name == 'SmartShot') {
          setState(() {
            ConnectDevice.smartShotDevice = device;
            ConnectDevice._foundDeviceWaitingToConnect = true;
            _connectToDevice();
          });
        }
      });
    }
  }

  // Connect to device
  void _connectToDevice() {
    // Stop scanning
    ConnectDevice._scanStream.cancel();

    // Connect to Smart Shot device. Method returns a stream to listen to connection state
    Stream<ConnectionStateUpdate> _currentConnectionStatus =
        ConnectDevice.flutterReactiveBLE.connectToDevice(
      id: ConnectDevice.smartShotDevice.id,
      connectionTimeout: const Duration(seconds: 5),
    );

    _currentConnectionStatus.listen((event) async {
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
            setState(() {
              ConnectDevice._foundDeviceWaitingToConnect = false;
              ConnectDevice._connected = true;
              ConnectDevice._connectedBefore = true;
              widget.onConnection();
            });

            // Pop the loading animation and the connect to device screen
            Navigator.of(context).pop();
            Navigator.of(context).pop();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Live Session'),
      ),
      body: startScan(),
    );
  }
}
