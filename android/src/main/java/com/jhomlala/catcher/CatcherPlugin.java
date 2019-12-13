package com.jhomlala.catcher;

import android.app.Activity;
import androidx.lifecycle.Lifecycle;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** CatcherPlugin */
public class CatcherPlugin implements MethodCallHandler, FlutterPlugin, ActivityAware {
  private static final String TAG = "CatcherPlugin";

  // These are null when not using v2 embedding.
  private MethodChannel channel;
  private Lifecycle lifecycle;

  private Activity activity;

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "catcher");
    channel.setMethodCallHandler(new CatcherPlugin());
  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {}

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {}

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    activity = binding.getActivity();
    lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding);
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromActivity() {}

  @Override
  public void onDetachedFromActivityForConfigChanges() {}

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {}

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }
}
