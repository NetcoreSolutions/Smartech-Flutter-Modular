package com.netcore.smartech_base

import android.app.Activity
import android.app.Application
import android.content.Context
import android.content.IntentFilter
import android.location.Location
import android.location.LocationManager
import android.util.Log
import androidx.annotation.NonNull
import com.netcore.android.Smartech
import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.ref.WeakReference

/** SmartechBasePlugin */
class SmartechBasePlugin: FlutterPlugin, MethodCallHandler, ActivityAware {

  private lateinit var channel : MethodChannel
  private var activityBinding: ActivityPluginBinding? = null //Ask for importance of usage
  private lateinit var activity: Activity
  private lateinit var smartech: Smartech

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "smartech_base_channel")
    channel.setMethodCallHandler(this)
    smartech = Smartech.getInstance(WeakReference(context))
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
    activityBinding = binding
    activity = binding.activity
    var flutterActivity = binding.activity as FlutterActivity
    var app = flutterActivity.applicationContext as Application
    setApplication(app)
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activityBinding = binding
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
  }

  private fun runOnMainThread(runnable: Runnable) {
    try {
      activity.runOnUiThread(runnable)
    } catch (e: Exception) {
      Log.e("FlutterPlugin", "Exception while running on main thread - ")
      e.printStackTrace()
    }
  }

  private fun updateUserProfile(payload: HashMap<String, Any>) {
    smartech.updateUserProfile(payload)
  }

  private fun setUserIdentity(userIdentity: String?) {
    smartech.setUserIdentity(userIdentity)
  }

  private fun login(userIdentity: String?) {
    smartech.login(userIdentity)
  }

  private fun setUserLocation(payload: HashMap<String, Any>) {

    var targetlocation = Location(LocationManager.GPS_PROVIDER)
    targetlocation.latitude = payload["latitude"] as Double
    targetlocation.longitude = payload["longitude"] as Double
    smartech.setUserLocation(targetlocation);
  }

  private fun trackEvent(payload: HashMap<String, Any>) {
    smartech.trackEvent(payload["event_name"] as String, payload["event_data"] as HashMap<String, Any>)
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

    fun initializePlugin() {

      //initialize Smartech Sdk
      Smartech.getInstance(WeakReference(context)).initializeSdk(application)

      //register broadcast receiver
      val deeplinkReceiver = SmartechDeeplinkReceivers()
      val filter = IntentFilter("com.smartech.EVENT_PN_INBOX_CLICK")
      application.registerReceiver(deeplinkReceiver, filter)
    }

    fun trackAppInstallUpdateBySmartech() {
      Smartech.getInstance(WeakReference(context)).trackAppInstallUpdateBySmartech()
    }

    fun setDebugLevel(level: Int) {
      Smartech.getInstance(WeakReference(context)).setDebugLevel(level)
    }

    fun trackAppInstall() {
      Smartech.getInstance(WeakReference(context)).trackAppInstall()
    }

    fun trackAppUpdate() {
      Smartech.getInstance(WeakReference(context)).trackAppUpdate()
    }

  }

}
