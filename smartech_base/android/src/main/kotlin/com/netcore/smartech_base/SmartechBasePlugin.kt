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
import com.netcore.android.inapp.InAppCustomHTMLListener
import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONArray
import org.json.JSONObject
import java.lang.ref.WeakReference

/** SmartechBasePlugin */
class SmartechBasePlugin: FlutterPlugin, MethodCallHandler, ActivityAware {

  private lateinit var channel : MethodChannel
  private lateinit var activity: Activity
  private lateinit var smartech: Smartech

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "smartech_base")
    channel.setMethodCallHandler(this)
    smartech = Smartech.getInstance(WeakReference(flutterPluginBinding.applicationContext))
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

    when(call.method){
      "setDebugLevel" -> {
        setDebugLevel(call.arguments as Int)
        result.success(null)
      }
      "trackAppInstall" -> {
        trackAppInstall()
        result.success(null)
      }
      "trackAppUpdate" -> {
        trackAppUpdate()
        result.success(null)
      }
      "trackAppInstallUpdateBySmartech" -> {
        trackAppInstallUpdateBySmartech()
        result.success(null)
      }
      "setInAppCustomHTMLListener" -> {
        val callback = object : InAppCustomHTMLListener {
          override fun customHTMLCallback(payload: HashMap<String, Any>?) {
            runOnMainThread(Runnable {
              channel.invokeMethod("setInAppCustomHTMLListener", payload)
            })
          }
          override fun onCustomHtmlInAppClick(deepLink: String?, payload: String?) {
          }
        }
        smartech.setInAppCustomHTMLListener(callback)
      }

      "setOnInAppClickListener" -> {
        val callback = object : InAppCustomHTMLListener {
          override fun customHTMLCallback(payload: HashMap<String, Any>?) {     
          }

          override fun onCustomHtmlInAppClick(deepLink: String?, payload: String?) {
            val map = HashMap<String, Any>()

            Log.d("onCustomHtmlInAppClick", "onCustomHtmlInAppClick")
            if(deepLink!=null)
            {
              map["smtDeeplink"] = deepLink
              Log.d("onCustomHtmlInAppClick deeplink", deepLink)
            }
            if(payload!=null)
            {
              map["smtCustomPayload"] = payload
              Log.d("onCustomHtmlInAppClick payload", payload)
            }
            // channel.invokeMethod("onCustomHtmlInAppClick", map)
            runOnMainThread(Runnable {
              channel.invokeMethod("onCustomHtmlInAppClick", map)
            })
          }
        }
        smartech.setInAppCustomHTMLListener(callback)
      }

      "updateUserProfile" -> {
        updateUserProfile(call.arguments as HashMap<String, Any>)
        result.success(null)
      }
      "setUserIdentity" -> {
        setUserIdentity(call.arguments as String)
        result.success(null)
      }
      "login" -> {
        login(call.arguments as String)
        result.success(null)
      }
      "clearUserIdentity" -> {
        smartech.clearUserIdentity()
        result.success(null)
      }
      "logoutAndClearUserIdentity" -> {
        smartech.logoutAndClearUserIdentity(call.arguments as Boolean)
        result.success(null)
      }
      "trackEvent" -> {
        trackEvent(call.arguments as HashMap<String, Any>)
        result.success(null)
      }
      "getDeviceUniqueId" -> {
        result.success(smartech.getDeviceUniqueId())
      }
      "setUserLocation" -> {
        setUserLocation(call.arguments as HashMap<String, Any>)
        result.success(null)
      }
      "optTracking" -> {
        smartech.optTracking(call.arguments as Boolean)
        result.success(null)
      }
      "hasOptedTracking" -> {
        result.success(smartech.hasOptedTracking())
      }
      "optInAppMessage" -> {
        smartech.optInAppMessage(call.arguments as Boolean)
        result.success(null)
      }
      "hasOptedInAppMessage" -> {
        result.success(smartech.hasOptedInAppMessage())
      }
      "processEventsManually" -> {
        smartech.processEventsManually()
        result.success(null)
      }
      "getUserIdentity" -> {
        result.success(smartech.getUserIdentity())
      }
      "getAppID" -> {
        result.success(smartech.getAppID())
      }
      "getSDKVersion" -> {
        result.success(smartech.getSDKVersion())
      }
      "setDeviceAdvertiserId" -> {
        smartech.setDeviceAdvertiserId(call.arguments as String)
        result.success(null)
      }
      "openNativeWebView" -> {
        openNativeWebView?.invoke()
        result.success(null)
      }      
      "onHandleDeeplinkAction" -> {
        Log.d("onHandleDeeplinkAction", "onHandleDeeplinkAction Invoke from smartech_base.kt")
        SmartechDeeplinkReceivers.deeplinkReceiverCallBack = { map ->
          Log.v("foreground mode payload :: ", "" + map)
          runOnMainThread(Runnable {
              channel.invokeMethod("onhandleDeeplinkAction", map, object : Result {
                override fun success(result: Any?) {
                  context.getSharedPreferences("Deeplink_action", Context.MODE_PRIVATE).edit().clear().apply()
                  Log.d("success", "success")
                }

                override fun error(code: String, msg: String?, details: Any?) {
                  if (msg != null) {
                    Log.d("success111", msg)
                  }
                }

                override fun notImplemented() {
                  Log.d("notImplemented", "notImplemented")
                }
              })
            })
        }
        result.success(null)
      }
      "onHandleDeeplinkActionBackground" -> {
        val smtDeeplinkSource = context.getSharedPreferences("Deeplink_action", Context.MODE_PRIVATE).getString("smtDeeplinkSource", null)
        val smtDeeplink = context.getSharedPreferences("Deeplink_action", Context.MODE_PRIVATE).getString("smtDeeplink", null)
        val smtPayload = context.getSharedPreferences("Deeplink_action", Context.MODE_PRIVATE).getString("smtPayload", null)
        val smtCustomPayload = context.getSharedPreferences("Deeplink_action", Context.MODE_PRIVATE).getString("smtCustomPayload", null)
        
        val map = HashMap<String, Any>()
       
        if(smtDeeplinkSource != null){
          map["smtDeeplinkSource"] = smtDeeplinkSource
        }
       
        if(smtDeeplink != null){
          map["smtDeeplink"] = smtDeeplink
        }

        if(smtPayload != null){
          val jsonObject = JSONObject(smtPayload)
          map["smtPayload"] = jsonToMap(jsonObject)
        }

        if(smtCustomPayload != null){
          val jsonObject = JSONObject(smtCustomPayload)
          map["smtCustomPayload"] = jsonToMap(jsonObject)
        }

        Log.v("backgroud mode payload :: ", "" + map)

          runOnMainThread(Runnable {
            channel.invokeMethod("onhandleDeeplinkAction", map, object : Result {
              override fun success(result: Any?) {
                context.getSharedPreferences("Deeplink_action", Context.MODE_PRIVATE).edit().clear().apply()
                Log.d("success", "success")
              }
              override fun error(code: String, msg: String?, details: Any?) {
                if (msg != null) {
                  Log.d("success111", msg)
                }
              }
              override fun notImplemented() {
                Log.d("notImplemented", "notImplemented")
              }
            })
          })
        result.success(null)
      }
      "openUrl" -> {
        openUrl?.invoke(call.arguments as String)
        result.success(null)
      }
      else -> result.notImplemented()
    }   
  }

  private fun jsonToMap(json: JSONObject): HashMap<String, Any> {
      var retMap = HashMap<String, Any>()
      if (json != JSONObject.NULL) {
          retMap = toMap(json)
      }
      return retMap
  }

  private fun toMap(object1: JSONObject): HashMap<String, Any> {
      val map = HashMap<String, Any>()
      try {
          val keysItr = object1.keys()
          while (keysItr.hasNext()) {
              val key = keysItr.next()
              var value = object1.get(key)

              if (value is JSONArray) {
                  value = toList(value)
              } else if (value is JSONObject) {
                  value = toMap(value)
              }
              map[key] = value
          }
      }catch (t: Throwable){
        t.printStackTrace()
      }
      return map
  }

  private fun toList(array: JSONArray): List<Any> {
      val list = ArrayList<Any>()
      try {
          for (i in 0 until array.length()) {
              var value = array.get(i)
              if (value is JSONArray) {
                  value = toList(value)
              } else if (value is JSONObject) {
                  value = toMap(value)
              }
              list.add(value)
          }
      }catch (t: Throwable){
          t.printStackTrace()
      }
      return list
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
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

    //App base context
    lateinit var context: Context

    var openNativeWebView : (()->Unit)? = null //Ask for importance of usage
    var openUrl : ((url: String?)->Unit)? = null //Ask for importance of usage

    fun initializePlugin(application: Application) {
      context = application.applicationContext

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
