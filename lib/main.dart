import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Smart Shot'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  // A Flutter Blue instance/object
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  // List of bluetooth devices
  final List<BluetoothDevice> deviceList = [];

  // Map to store values by the characteristics
  final Map<Guid, List<int>> readValues = <Guid, List<int>>{};

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BluetoothDevice? _connectedDevice;
  List<BluetoothService> _services = [];

  @override
  void initState() {
    // Runs when first made
    super.initState();

    // We won't see devices that are already connected  when we scan, so we add already connected devices to the list
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceToList(device);
      }
    });

    // Define what to do with the scan results once we scan
    widget.flutterBlue.scanResults.listen((List<ScanResult> scanResults) {
      for (ScanResult scanResult in scanResults) {
        _addDeviceToList(scanResult.device);
      }
    });

    // Start scan
    widget.flutterBlue.startScan();
  }

  // Connect button onclick function
  void _connectDevice(BluetoothDevice device) {
    setState(() async {
      // Allows us to use await
      // Stop scanning for ble devices
      widget.flutterBlue.stopScan();

      // Connect to device BluetoothDevice.connect is an asyns function that could throw error messages
      try {
        await device
            .connect(); // returns a Future<void> instance so we need to use await
      } catch (error) {
        // Error handling
        if (error.toString() != 'already_connected') {
          rethrow;
        }
      } finally {
        _services = await device
            .discoverServices(); // Get a list of the divice's services if connected successfully
      }

      setState(() {
        _connectedDevice = device; // Set _connectedDevice to passed in device
      });
    });
  }

  // Add device to list if it's not already in there
  void _addDeviceToList(final BluetoothDevice device) {
    if (!widget.deviceList.contains(device)) {
      setState(() {
        widget.deviceList.add(device);
      });
    }
  }

  // Create a ListView using the device list
  ListView _buildListViewOfDevices() {
    List<Container> containers = [];

    for (BluetoothDevice device in widget.deviceList) {
      containers.add(Container(
        height: 50,
        child: Row(children: <Widget>[
          Expanded(
            child: Column(children: <Widget>[
              Text(device.name == '' ? '(unknown device)' : device.name),
              Text(device.id.toString()),
            ]),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              print('Connecting...');
              _connectDevice(device);
            },
            child: const Text(
              "Connect",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ]),
      ));
    }

    // Return the ListView
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers, // Puts all the items of containers, which are Containers, within the children list of the list view
      ],
    );
  }

  // Create a ListView for the connected device listing its services
  ListView _buildConnectedDeviceView() {
    // List of all of our containers for each service
    List<Container> containers = [];

    for (BluetoothService service in _services) {
      List<Widget> characteristicsWidget = [];

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        characteristic.value.listen((value) {
          // Might test out read
          print(value);
        });
        characteristicsWidget.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      characteristic.uuid.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    ..._buildReadWriteNotifyButton(characteristic),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Value: ${widget.readValues[characteristic.uuid]}'),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        );
      }

      containers.add(
        Container(
          child: ExpansionTile(
            title: Text(service.uuid.toString()),
            children: characteristicsWidget,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  // Return a list view based on whether we're connected to a device or not
  ListView _buildView() {
    if (_connectedDevice != null) {
      return _buildConnectedDeviceView();
    }

    return _buildListViewOfDevices();
  }

  void readCharacteristic(BluetoothCharacteristic characteristic) {
    //print('Hello');
    setState(() async {
      List<int> value = await characteristic.read();

      //print(value);
    });
  }

  // Create buttons
  List<TextButton> _buildReadWriteNotifyButton(
      BluetoothCharacteristic characteristic) {
    // List of buttons
    List<TextButton> buttons = [];

    // Read characteristics
    if (characteristic.properties.read) {
      buttons.add(
        TextButton(
          style: TextButton.styleFrom(
            textStyle: TextStyle(fontSize: 20),
            backgroundColor: Colors.blue,
          ),
          onPressed: () {
            print('Hello');
            // setState(() {
            //   characteristic.read().then((value) {
            //     widget.readValues[characteristic.uuid] = value;
            //     print("Value: $value");
            //   });
            // });

            // var subscription = characteristic.value.listen((value) {
            //   //Listen for value
            //   setState(() {
            //     widget.readValues[characteristic.uuid] = value; // Set value
            //   });
            // });
            // await characteristic.read();
            // subscription.cancel();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: () {},
              child: const Text('READ'),
            ),
          ),
        ),
      );
    }

    // Write characteristics
    if (characteristic.properties.write) {
      buttons.add(
        TextButton(
          style: TextButton.styleFrom(
            textStyle: TextStyle(fontSize: 20),
            backgroundColor: Colors.blue,
          ),
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: () {},
              child: const Text('WRITE'),
            ),
          ),
        ),
      );
    }

    // Notify characteristics
    if (characteristic.properties.notify) {
      buttons.add(
        TextButton(
          style: TextButton.styleFrom(
            textStyle: TextStyle(fontSize: 20),
            backgroundColor: Colors.blue,
          ),
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: () {},
              child: const Text('NOTIFY'),
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: _buildView(),
    );
  }
}
