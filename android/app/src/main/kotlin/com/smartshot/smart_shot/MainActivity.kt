package com.smartshot.smart_shot

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import org.opencv.android.OpenCVLoader


class MainActivity: FlutterActivity() {
  private val _channel = "smartshot/opencv"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
      MethodChannel(flutterEngine.dartExecutor.binaryMessenger, _channel).setMethodCallHandler { call, result ->
      // This method is invoked on the main thread.
      if (call.method == "processImage") {
        if (OpenCVLoader.initDebug()) {
          if (call.hasArgument("path")) {
            val path = call.argument<String>("path");

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
