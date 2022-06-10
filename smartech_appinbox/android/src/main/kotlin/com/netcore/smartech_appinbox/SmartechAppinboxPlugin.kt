package com.netcore.smartech_appinbox
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.netcore.android.smartechappinbox.SmartechAppInbox;
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import android.content.Context
import android.app.Application
import java.lang.ref.WeakReference
import android.app.Activity

/** SmartechAppinboxPlugin */
class SmartechAppinboxPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var smartAppInbox : SmartechAppInbox
  private lateinit var activity : Activity

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "smartech_appinbox")
    channel.setMethodCallHandler(this)
    smartAppInbox = SmartechAppInbox.getInstance(WeakReference(flutterPluginBinding.applicationContext))
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
      when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "displayAppInbox" -> {
        if(activity!=null)
        smartAppInbox.displayAppInbox(activity)
        result.success(null)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

     override fun onDetachedFromActivity() {
///       activity = null;
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity;
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity;
    }

    override fun onDetachedFromActivityForConfigChanges() {
///        activity = null;
    }
  
    companion object{

        //App base context
        lateinit var context: Context

        fun initializePlugin(application: Application) {
            context = application.applicationContext
        }

    }
}
