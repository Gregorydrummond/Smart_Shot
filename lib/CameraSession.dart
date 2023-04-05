import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'dart:async';

class CameraSession extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Function ballDetected;
  const CameraSession({super.key, required this.cameras, required this.ballDetected});

  @override
  State<CameraSession> createState() => _CameraSessionState();
}

class _CameraSessionState extends State<CameraSession> {
  static const platform = MethodChannel('smartshot/opencv');

  List<int> boundingBox = [0];
  int frame = 0;
  GlobalKey camKey = GlobalKey();

  late CameraController controller;
  late Future<void> controllerInit;
  double zoom = 1.0;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.low);
    controllerInit = controller.initialize()
    .then((_) async {
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
  Future<void> dispose() async {
    super.dispose();
    try {
      await controller.stopImageStream();
    } catch (e) {}
    await platform.invokeMethod('endProcessing');
    await controller.dispose();
  }

  Future<void> _processImage({required int width, required int height, required Uint8List bytes}) async {
    try {
      boundingBox = await platform.invokeMethod('processImage', {"width": width, "height": height, "bytes": bytes});
      if (boundingBox[0] == 3) {
        widget.ballDetected();
      }
      setState(() {});
    } on PlatformException catch (e) {
      return;
    }
  }

  void _startTracking() {
    controller.setExposureMode(ExposureMode.locked);
    controller.setFocusMode(FocusMode.locked);
    controller.startImageStream((image) async {
      await _processImage(width: image.width, height: image.height, bytes: image.planes[0].bytes);
    });
  }

  List<Widget> buildWidgets() {
    List<Widget> widgets = [];
    widgets.add(buildCamera());
    
    if (boundingBox[0] == 0) {
      widgets.add(buildPrompt());
    }
    else {
      widgets.add(buildBoundingBoxWidget());
    }

    return widgets;
  }

  Widget buildPrompt() {
    try {
      return FutureBuilder(
        future: Future.wait([controller.getMaxZoomLevel(), controller.getMinZoomLevel()]),
        builder: (context, AsyncSnapshot<List<double>> snapshot) {
          if (snapshot.hasData) {
            try {
              double height = 0;
              RenderBox renderBox = camKey.currentContext!.findRenderObject() as RenderBox;
              height = renderBox.size.height;
              List<Widget> widgets = [];
              widgets.addAll(buildCameraGuides());

              widgets.add(Container(
                height: height,
                padding: EdgeInsets.only(top: height * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Text("Position camera so that the hoop fills the view", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,)),
                        TextButton(
                          onPressed: _startTracking,
                          style: TextButton.styleFrom(backgroundColor: Colors.orangeAccent),
                          child: const Text("Start Camera Tracking", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
                        ),
                      ],
                    ),
                    Slider(
                      value: zoom,
                      max: snapshot.data![0],
                      min: snapshot.data![1],
                      onChanged: (double value) {
                        setState(() {
                          zoom = value;
                          controller.setZoomLevel(zoom);
                        });
                      }
                    ),
                  ],
                ),
              ));
              return Stack(children: widgets);
            }
            catch (e) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator()]
                ),
              );
            }
          }
          else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()]
              ),
            );
          }
      });
    }
    catch (e) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator()]
        ),
      );
    }
  }

  Widget buildBoundingBoxWidget() {
    final size = MediaQuery.of(context).size;
    Widget box = Container();

    try {
      RenderBox renderBox = camKey.currentContext!.findRenderObject() as RenderBox;
      double height = renderBox.size.height;

      if (boundingBox[0] == 2) {
        box = Positioned(
          left: (boundingBox[1] / boundingBox[5]) * size.width,
          top: (boundingBox[2] / boundingBox[6]) * height,
          width: (boundingBox[3] / boundingBox[5]) * size.width,
          height: (boundingBox[4] / boundingBox[6]) * height,
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 0, 255, 0), width: 2.0)),
            child: const Text("", style: TextStyle(color: Color.fromARGB(255, 0, 255, 0))),
          )
        );
      }
    } catch (e) {
      print(e);
    }

    return box;
  }

  List<Widget> buildCameraGuides() {
    List<Widget> guide = [Container()];
    final size = MediaQuery.of(context).size;

    try {
      RenderBox renderBox = camKey.currentContext!.findRenderObject() as RenderBox;
      double height = renderBox.size.height;

      if (height > size.width) {
        guide = [
            Positioned(
              left: 0,
              top: size.width,
              width: size.width,
              height: height - size.width,
              child: Container(
                color: Color.fromARGB(145, 0, 0, 0)
              )
            ),
            Positioned(
              left: 0,
              top: 0,
              width: size.width,
              height: size.width,
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Color.fromARGB(145, 0, 0, 0), width: size.width*0.2)),
              )
            )
          ];
      }
    } catch (e) {
      print("Probably need a future builder");
    }

    return guide;
  }

  Widget buildCamera() => CameraPreview(controller, key: camKey);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: buildWidgets()
    );
  }

  //Widget buildCamera() => CameraPreview(controller, key : camKey);
}
