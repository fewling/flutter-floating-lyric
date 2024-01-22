package com.example.floating_lyric.features.permissions

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PermissionMethodCallHandler : FlutterPlugin, MethodChannel.MethodCallHandler {

    companion object {
        private const val TAG = "PermissionMethodHandler"
        private const val CHANNEL = "floating_lyric/permission_method_channel"
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        TODO("Not yet implemented")
    }
}