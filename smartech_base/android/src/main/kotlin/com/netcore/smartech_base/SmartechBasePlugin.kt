package com.netcore.smartech_base

import android.app.Application
import android.content.Context
import android.content.IntentFilter
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** SmartechBasePlugin */
class SmartechBasePlugin: FlutterPlugin, MethodCallHandler, ActivityAware {

  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "smartech_base_channel")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    var activity = binding.activity as FlutterActivity
    var app = activity.applicationContext as Application
    setApplication(app)
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
  }

  override fun onDetachedFromActivity() {
  }

  companion object{

    //Application object
    private lateinit var application: Application
    //App base context
    lateinit var context: Context

    var DRAWABLE = "drawable"   //Ask for importance of usage
    val deeplinkReceiver = SmartechDeeplinkReceivers() //Ask for importance of usage
    val filter = IntentFilter("com.smartech.EVENT_PN_INBOX_CLICK") //Ask for importance of usage
    var openNativeWebView : (()->Unit)? = null //Ask for importance of usage
    var openUrl : ((url: String?)->Unit)? = null //Ask for importance of usage

    fun getApplication(): Application {
      return application
    }

    fun setApplication(application: Application){
      SmartechBasePlugin.application = application
      context = application.baseContext
    }


  }

}
