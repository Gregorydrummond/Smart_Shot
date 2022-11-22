package com.smartshot.smart_shot

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.opencv.android.OpenCVLoader
import org.opencv.objdetect.CascadeClassifier
import java.io.File
import java.io.FileOutputStream


class MainActivity: FlutterActivity() {
  private val _channel = "smartshot/opencv";
  private var _opencvLoaded = false;
  private lateinit var haarFace: CascadeClassifier;

  override fun onFlutterUiDisplayed() {
    super.onFlutterUiDisplayed()
    if (!_opencvLoaded && OpenCVLoader.initDebug()) {
//      val haarUri: Uri = Uri.parse("android.resource://com.shartshot.smart_shot/" + R.drawable.haarcascade_frontalface_alt2);
//      haarFacePath = haarUri.path.toString();
      val `is` = resources.openRawResource(R.raw.haarcascade_frontalface_alt2);
      val cascadeDir = getDir("cascade", MODE_PRIVATE);
      val caseFile = File(cascadeDir, "haarcascade_frontalface_alt2.xml");

      val fos: FileOutputStream = FileOutputStream(caseFile);

      val buffer = ByteArray(4096);
      var bytesRead: Int;

      while (`is`.read(buffer).also { bytesRead = it } != -1) {
        fos.write(buffer, 0, bytesRead);
      }
      `is`.close();
      fos.close();

      haarFace = CascadeClassifier(caseFile.absolutePath);

      if(!haarFace.empty()){
        cascadeDir.delete();
        _opencvLoaded = true;
      }
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
//            if (!image.empty()) {

              result.success("Success");
//            }
//            else {
//              result.error("IMAGE ERROR", "Was not able to load image", null);
//            }
          }
          else {
            result.error("ARGUMENT ERROR", "Path not provided.", null);
          }
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
