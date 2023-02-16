import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:async';

class CameraSession extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraSession({super.key, required this.cameras});

  @override
  State<CameraSession> createState() => _CameraSessionState();
}

class _CameraSessionState extends State<CameraSession> {
  static const platform = MethodChannel('smartshot/opencv');

  List<int> boundingBox = [0];
  int frame = 0;
  GlobalKey camKey = GlobalKey();

  late CameraController controller;
  double zoom = 1.0;
  double maxZoom = 1.0;
  double minZoom = 1.0;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.low);
    controller.initialize().then((_) async {
      if (!mounted) {
        return;
      }
      maxZoom = await controller.getMaxZoomLevel();
      minZoom = await controller.getMinZoomLevel();
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
    controller.stopImageStream();
    platform.invokeMethod('endPorcessing');
    controller.dispose();
    super.dispose();
  }

  Future<void> _processImage({required int width, required int height, required Uint8List bytes}) async {
    try {
      if (frame % 1 == 0) {
        frame = 1;
        boundingBox = await platform.invokeMethod('processImage', {"width": width, "height": height, "bytes": bytes});
        setState(() {});
      }
      else {
        frame += 1;
      }
    } on PlatformException catch (e) {
      return;
    }
  }

  void _startTracking() {
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
    double height = 0;
    try {
      RenderBox renderBox = camKey.currentContext!.findRenderObject() as RenderBox;
      height = renderBox.size.height;
    }
    catch (e) {}
    return 
    Center(
      child: 
      Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
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
              max: maxZoom,
              min: minZoom,
              onChanged: (double value) {
                setState(() {
                  zoom = value;
                  controller.setZoomLevel(zoom);
                });
              }
            ),
          ],
        ),
      )
    );
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
            child: const Text("Ball", style: TextStyle(color: Color.fromARGB(255, 0, 255, 0))),
          )
        );
      }
    } catch (e) {
      print(e);
    }

    return box;
  }

  Widget buildCamera() => CameraPreview(controller, key: camKey);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: buildWidgets()
    );
  }

}
