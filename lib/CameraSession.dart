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

  Future<void> _processImage({required int width, required int height, required Uint8List bytes}) async {
    try {
      boundingBox = await platform.invokeMethod('processImage', {"width": width, "height": height, "bytes": bytes});
      setState(() {});
    } on PlatformException catch (e) {
      // print(e);
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.low);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      controller.startImageStream((image) async {
        if (frame == 3) {
          frame = 0;
          await _processImage(width: image.width, height: image.height, bytes: image.planes[0].bytes);
        }
        else {
          frame += 1;
        }
      });
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
    controller.dispose();
    super.dispose();
  }

  Widget boundingBoxWidget() {
    final size = MediaQuery.of(context).size;
    Widget box = Container();

    try {
      RenderBox renderBox = camKey.currentContext!.findRenderObject() as RenderBox;
      double height = renderBox.size.height;

      if (boundingBox[0] == 1) {
        box = Positioned(
          left: (boundingBox[1] / 240) * size.width,
          top: (boundingBox[2] / 340) * height,
          width: (boundingBox[3] / 240) * size.width,
          height: (boundingBox[4] / 340) * height,
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Color.fromARGB(255, 0, 255, 0))),
            child: Text("Face", style: TextStyle(color: Color.fromARGB(255, 0, 255, 0)),),
          )
        );
      }
    } catch (e) {
      print(e);
    }

    return box;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildCamera(),
          boundingBoxWidget()
        ]
      ),
    );
  }

  Widget buildCamera() => CameraPreview(controller, key: camKey);
}
