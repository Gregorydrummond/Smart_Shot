package com.smartshot.smart_shot

import android.os.Bundle
import android.os.PersistableBundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.opencv.android.OpenCVLoader
import org.opencv.core.Mat
import org.opencv.imgcodecs.Imgcodecs.imread
import org.opencv.objdetect.CascadeClassifier


class MainActivity: FlutterActivity() {
  private val _channel = "smartshot/opencv";
  private var _opencvLoaded = false;
  var faceDetector: CascadeClassifier? = null;

  override fun onFlutterUiDisplayed() {
    super.onFlutterUiDisplayed()
    if (!_opencvLoaded && OpenCVLoader.initDebug()) {
      _opencvLoaded = true;
    }
  }

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
      MethodChannel(flutterEngine.dartExecutor.binaryMessenger, _channel).setMethodCallHandler { call, result ->
      // This method is invoked on the main thread.
      if (call.method == "processImage") {
        if (_opencvLoaded) {
          if (call.hasArgument("path")) {
            val path = call.argument<String>("path");
//            var image: Mat = imread(path);
            result.success("$path/success");
          }
          else {
            result.error("ARGUMENT ERROR", "Path not provided.", null);
          }
          result.success(null);
        }
        else {
          result.error("UNAVAILABLE", "Opencv not available.", null);
        }
      }
      else {
        result.notImplemented();
      }
    }
  }
}
