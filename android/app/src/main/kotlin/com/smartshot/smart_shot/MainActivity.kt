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
  private var backgroundFrames = 0;
  private var missingFrames = 0;
  private lateinit var background: Mat;
  private lateinit var summedImage: Mat;
  private var differenceFrames = ArrayList<Mat>();

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
            if (calculateBackground && backgroundFrames < 1) {
              if (backgroundFrames == 0) {
                background = image;
//                imwrite(dcim.absolutePath + "/background1.png", background);
              }
              else {
                divide(image, Scalar(2.0), image);
                divide(background, Scalar(2.0), background);
                add(image, background, background);
              }
              backgroundFrames++;
              val value = IntArray(1);
              value[0] = 1;
              result.success(value);
              returned = true;
            }
            else if (calculateBackground && backgroundFrames == 1) {
              calculateBackground = false;
//              imwrite(dcim.absolutePath + "/background.png", background);
              val value = IntArray(1);
              value[0] = 1;
              result.success(value);
              returned = true;
            }

            // Try to detect moving ball
            if (!returned) {
              absdiff(background, image, image);
              threshold(image, image, 50.0, 255.0, THRESH_BINARY);
              val kernel = getStructuringElement(MORPH_RECT, Size(3.0, 3.0))
              dilate(image, image, kernel);

              if (differenceFrames.size == 0) {
                differenceFrames.add(image);
                summedImage = image;
                val value = IntArray(1);
                value[0] = 3;
                result.success(value);
                returned = true;
              }
              else if (differenceFrames.size != 4) {
                differenceFrames.add(image);
                add(image, summedImage, summedImage);
                val value = IntArray(1);
                value[0] = 3;
                result.success(value);
                returned = true;
              }
              else {
                differenceFrames.removeFirst();
                differenceFrames.add(image);
                for (i in 0 until  differenceFrames.size) {
                  if (i == 0) {
                    summedImage = differenceFrames[i];
                    continue;
                  }
                  add(summedImage, differenceFrames[i], summedImage);
                }
              }

              if (!returned) {
                // Find the contours
                var contours: List<MatOfPoint> = ArrayList<MatOfPoint>();
                var hierarchy = Mat();
                findContours(summedImage, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);

                var ballDetected = false;
                var rect = Rect();

                // find the contour for the ball
                for (contour in contours) {
                  val bbox = boundingRect(contour);
                  val ratio = (bbox.width * bbox.height) / (summedImage.width() * summedImage.height() + 0.0)

                  // too big, too small, not square enough
                  if (ratio < 0.01 || ratio > 0.25 || bbox.width / (bbox.height + 0.0) < 0.8 || bbox.width / (bbox.height + 0.0) > 1.2) {
                    continue;
                  }

                  // starts from too low in the screen
//                  if (!shotIsLive && bbox.y + (bbox.height/2) > summedImage.height() * 0.65) {
//                    continue;
//                  }

                  ballDetected = true;
                  rect = bbox;
                  bbox.discard()
                  if (!shotIsLive) {
                    shotIsLive = true;
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
                  value[0] = 2;
                  value[1] = rect.x;
                  value[2] = rect.y;
                  value[3] = rect.width;
                  value[4] = rect.height;
                  value[5] = summedImage.width();
                  value[6] = summedImage.height();
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
        backgroundFrames = 0;
        missingFrames = 0;
        result.success(0);
      }
      else {
        result.notImplemented();
      }
    }
  }
}