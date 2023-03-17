package com.smartshot.smart_shot

import android.os.Environment
import androidx.annotation.NonNull
import com.signify.hue.flutterreactiveble.utils.discard
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.opencv.android.OpenCVLoader
import org.opencv.core.*
import org.opencv.core.Core.*
import org.opencv.imgcodecs.Imgcodecs.imwrite
import org.opencv.imgproc.Imgproc.*
import org.opencv.objdetect.CascadeClassifier
import org.opencv.objdetect.Objdetect.CASCADE_SCALE_IMAGE


class MainActivity: FlutterActivity() {
  private val _channel = "smartshot/opencv";
  private var _opencvLoaded = false;
  private var calculateBackground = true;
  private var shotIsLive = false;
  private var firstFrame = false;
  private var missingFrames = 0;
  private var waitFrames = 0;
  private lateinit var background: Mat;

  private val dcim = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM);

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
          if (call.hasArgument("width") && call.hasArgument("height") && call.hasArgument("bytes")) {
            val width = call.argument<Int>("width")!!;
            val height = call.argument<Int>("height")!!;
            val bytes = call.argument<ByteArray>("bytes");
            var image: Mat = Mat(height, width, CvType.CV_8UC1);
            image.put(0,0, bytes);

            rotate(image, image, ROTATE_90_CLOCKWISE);
            GaussianBlur(image, image, Size(7.0, 7.0), 0.0);

            // Calculate the background reference
            var returned = false;
            if (waitFrames < 60) {
              waitFrames += 1;
              val value = IntArray(1);
              value[0] = 1;
              result.success(value);
              returned = true;
            }
            else if (calculateBackground) {
              background = image;
              calculateBackground = false;
              val value = IntArray(1);
              value[0] = 1;
              result.success(value);
              returned = true;
            }

            // Try to detect moving ball
            if (!returned) {
              var dif = Mat();
              var max = Mat();
              var min = Mat();
//              absdiff(background, image, dif);
              max(background, image, max);
              min(background, image, min);
              addWeighted(background, 0.98, image, 0.02, 0.0, background);

//              threshold(dif, dif, 30.0, 255.0, THRESH_BINARY);
              threshold(dif, dif, 1.2, 255.0, THRESH_BINARY);
              val kernel = getStructuringElement(MORPH_RECT, Size(3.0, 3.0));
              erode(dif, dif, kernel, Point(-1.0, -1.0), 2);
              dilate(dif, dif, kernel, Point(-1.0, -1.0), 2);

              if (!returned) {
                // Find the contours
                var contours: List<MatOfPoint> = ArrayList<MatOfPoint>();
                var hierarchy = Mat();
                findContours(dif, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);

                var ballDetected = false;
                var rect = Rect();

                // find the contour for the ball
                for (contour in contours) {
                  val bbox = boundingRect(contour);
                  val ratio = (bbox.width * bbox.height) / (dif.width() * dif.height() / 2.0)

                  // too big, too small, not square enough
                  if (ratio < 0.01 || ratio > 0.25 || bbox.width / (bbox.height + 0.0) < 0.8 || bbox.width / (bbox.height + 0.0) > 1.2) {
                    continue;
                  }

                  // starts from too low in the screen
                  if (!shotIsLive && bbox.y + (bbox.height/2) > dif.height() * 0.5) {
                    continue;
                  }

                  ballDetected = true;
                  missingFrames = 0;
                  rect = bbox;
                  bbox.discard()
                  if (!shotIsLive) {
                    shotIsLive = true;
                    firstFrame = true;
                    missingFrames = 0;
                  }
                  break;
                }

                if (shotIsLive && !ballDetected) {
                  missingFrames++;
                  if (missingFrames == 25) {
                    shotIsLive = false;
                    missingFrames = 0;
                  }
                }

                if (!ballDetected) {
                  val value = IntArray(1);
                  value[0] = 4;
                  result.success(value);
                }
                else {
                  val value = IntArray(7);
                  if (firstFrame) {
                    value[0] = 3;
                    firstFrame = false;
                  }
                  else {
                    value[0] = 2;
                  }
                  value[1] = rect.x;
                  value[2] = rect.y;
                  value[3] = rect.width;
                  value[4] = rect.height;
                  value[5] = dif.width();
                  value[6] = dif.height();
                  result.success(value);
                }
              }
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
      else if (call.method == "endProcessing") {
        calculateBackground = true;
        shotIsLive = false;
        firstFrame = false;
        missingFrames = 0;
        waitFrames = 0;
        result.success(0);
      }
      else {
        result.notImplemented();
      }
    }
  }
}