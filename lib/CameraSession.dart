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
    controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
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
