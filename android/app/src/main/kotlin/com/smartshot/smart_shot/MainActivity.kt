package com.smartshot.smart_shot

import androidx.annotation.NonNull
import com.signify.hue.flutterreactiveble.utils.discard
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.opencv.android.OpenCVLoader
import org.opencv.core.Core.*
import org.opencv.core.CvType
import org.opencv.core.Mat
import org.opencv.core.MatOfRect
import org.opencv.core.Scalar
import org.opencv.core.Size
import org.opencv.imgcodecs.Imgcodecs.imread
import org.opencv.imgcodecs.Imgcodecs.imwrite
import org.opencv.imgproc.Imgproc.*
import org.opencv.objdetect.CascadeClassifier
import org.opencv.objdetect.Objdetect.CASCADE_SCALE_IMAGE
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
          if (call.hasArgument("width") && call.hasArgument("height") && call.hasArgument("bytes")) {
            val width = call.argument<Int>("width")!!;
            val height = call.argument<Int>("height")!!;
            val bytes = call.argument<ByteArray>("bytes");
            var image: Mat = Mat(height, width, CvType.CV_8UC1);
            image.put(0,0, bytes);
            rotate(image, image, ROTATE_90_CLOCKWISE)
            val rects = detectFace(image, haarFace);
            image.release();
            if (rects.empty()) {
              val value = IntArray(1);
              value[0] = 0;
              rects.discard();
              result.success(value);
            }
            else {
              val rect = rects.toArray()[0];
              val value = IntArray(5);
              value[0] = 1;
              value[1] = rect.x;
              value[2] = rect.y;
              value[3] = rect.width;
              value[4] = rect.height;
              rect.discard();
              result.success(value);
            }
          }
          else {
            result.error("ARGUMENT ERROR", "Invalid arguments provided.", null);
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

  fun detectFace(image: Mat, cascade: CascadeClassifier): MatOfRect {
    var rectangles = MatOfRect();
    val minSize = Size(30.0, 30.0);
    cascade.detectMultiScale(image, rectangles, 1.1, 5, CASCADE_SCALE_IMAGE, minSize);
    return rectangles;
  }

  fun drawRectangles(image: Mat, rects: MatOfRect) {
    if (rects.empty()) {
      return;
    }
    val color = Scalar(0.0, 255.0, 0.0);
    for (rect in rects.toList()) {
      rectangle(image, rect, color, 2);
    }
  }
}