package com.hong.flutter_bugly;

import android.content.Context;

import androidx.annotation.NonNull;

import com.tencent.bugly.crashreport.CrashReport;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterBuglyPlugin */
public class FlutterBuglyPlugin implements MethodCallHandler {

  private Context appContext;

  private FlutterBuglyPlugin(Context appContext) {
    this.appContext = appContext;
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_bugly");
    channel.setMethodCallHandler(new FlutterBuglyPlugin(registrar.context().getApplicationContext()));
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "initBugly":
        String appId = call.argument("appId");
        String channel = call.argument("channel");
        String version = call.argument("version");
        CrashReport.UserStrategy strategy = new CrashReport.UserStrategy(appContext);
        strategy.setAppChannel(channel);
        strategy.setAppVersion(version);
        CrashReport.initCrashReport(appContext, appId, false, strategy);
        result.success(null);
        break;
      case "setUserId":
        String userId = call.argument("userId");
        CrashReport.setUserId(appContext, userId);
        result.success(null);
        break;
      case "postCatchedException":
        String message = "";
        String detail = null;
        Map<String, String> map = null;
        if (call.hasArgument("message")) {
          message = call.argument("message");
        }
        if (call.hasArgument("detail")) {
          detail = call.argument("detail");
        }
        if (call.hasArgument("data")) {
          map = call.argument("data");
        }
        CrashReport.postException(8, "Flutter Exception", message, detail, map);
        result.success(null);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

}