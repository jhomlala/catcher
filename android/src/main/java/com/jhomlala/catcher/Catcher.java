package com.jhomlala.catcher;

import android.content.Context;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class Catcher implements FlutterPlugin {

    private MethodChannel methodChannel;
    private EventChannel eventChannel;

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        setupChannels(binding.getBinaryMessenger(), binding.getApplicationContext());
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        teardownChannels();
    }


    private void setupChannels(BinaryMessenger messenger, Context context) {
        methodChannel = new MethodChannel(messenger, "catcher");
        eventChannel = new EventChannel(messenger, "catcher_event");
    }

    private void teardownChannels() {
        methodChannel = null;
        eventChannel = null;
    }
}
