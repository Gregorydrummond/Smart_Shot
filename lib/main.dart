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
  final List<BluetoothDevice> deviceList =  [];

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  void initState() {
    super.initState();

    // We won't see devices that are already connected  when we scan, so we add already connected devices to the list
    widget.flutterBlue.connectedDevices.asStream().listen((List<BluetoothDevice> devices) {
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
    widget.flutterBlue.startScan(
      timeout: const Duration(seconds: 5),
    );
  }

  int _counter = 0;
  String led = "Off";

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  // Add device to list if it's not already in there
  void _addDeviceToList(final BluetoothDevice device) {
    if(!widget.deviceList.contains(device)) {
      setState(() {
        widget.deviceList.add(device);
      });
    }
  }
  
  // Create a ListView using the device list
  ListView _buildListViewOfDevices() {
    List<Container> containers = [];

    for (BluetoothDevice device in widget.deviceList) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.name == '' ? '(unknown device' : device.name),
                    Text(device.id.toString()),
                  ]
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: TextStyle(fontSize: 20),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {}, 
                child: const Text(
                  "Connect",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ]
          ),
        )
      );
    }

    // Return the ListView
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
          ...containers,      // Puts all the items of containers, which are Containers, within the children list of the list view
      ],
    );
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
      body: _buildListViewOfDevices(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}