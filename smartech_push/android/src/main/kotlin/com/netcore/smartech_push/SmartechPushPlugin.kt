package com.netcore.smartech_push

import android.app.Application
import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.netcore.android.smartechpush.SmartPush
import com.netcore.android.smartechpush.notification.SMTNotificationOptions
import com.netcore.android.smartechpush.notification.channel.SMTNotificationChannel
import java.lang.ref.WeakReference

/** SmartechPushPlugin */
class SmartechPushPlugin: FlutterPlugin, MethodCallHandler {

  private lateinit var channel : MethodChannel
  private lateinit var smartPush: SmartPush

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "smartech_push")
    channel.setMethodCallHandler(this)
    smartPush = SmartPush.getInstance(WeakReference(flutterPluginBinding.applicationContext))
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

    when (call.method) {
      "setDevicePushToken" -> {
        smartPush.setDevicePushToken(call.arguments as String)
        result.success(null)
      }
      "fetchAlreadyGeneratedTokenFromFCM" -> {
        result.success(smartPush.fetchAlreadyGeneratedTokenFromFCM())
      }
      "handlePushNotification" -> {
        smartPush.handlePushNotification(call.arguments as String)
        result.success(null)
      }
      "createNotificationChannel" -> {
        createNotificationChannel(call.arguments as HashMap<String, Any>)
        result.success(null)
      }
      "createNotificationChannelGroup" -> {
        var payload = call.arguments as HashMap<String, Any>;
        smartPush.createNotificationChannelGroup(payload["group_id"] as String, payload["group_name"] as String)
        result.success(null)
      }
      "deleteNotificationChannel" -> {
        smartPush.deleteNotificationChannel(call.arguments as String)
        result.success(null)
      }
      "deleteNotificationChannelGroup" -> {
        smartPush.deleteNotificationChannelGroup(call.arguments as String)
        result.success(null)
      }
      "setNotificationOptions" -> {
        setNotificationOptions(call.arguments as HashMap<String, Any>)
        result.success(null)
      }
      "optPushNotification" -> {
        smartPush.optPushNotification(call.arguments as Boolean)
        result.success(null)
      }
      "hasOptedPushNotification" -> {
        result.success(smartPush.hasOptedPushNotification())
      }
      "getDevicePushToken" -> {
        result.success(smartPush.getDevicePushToken())
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun createNotificationChannel(payload: HashMap<String, Any>) {
    val builder : SMTNotificationChannel.Builder =  SMTNotificationChannel.Builder(
      payload["Channel_ID"] as String,
      payload["Channel_Name"] as String,
      payload["Notification_Importance"] as Int
    )
    if (payload["Channel_Description"] != null) {
      builder.setChannelDescription(payload["Channel_Description"] as String)
    }

    if (payload["Group_ID"] != null) {
      builder.setChannelGroupId(payload["Group_ID"] as String)
    }

    if (payload["Sound_File_Name"] != null) {
      builder.setNotificationSound(payload["Sound_File_Name"] as String)
    }

    val smtNotificationChannel: SMTNotificationChannel = builder.build()
    smartPush.createNotificationChannel(smtNotificationChannel)
  }

  private fun setNotificationOptions(payload: HashMap<String, Any>) {
    val option = SMTNotificationOptions(context)
    if (payload["smallIconTransparentId"] != null) {
      option.smallIconTransparent = payload["smallIconTransparentId"] as String
    }
    if (payload["largeIconId"] != null) {
      option.largeIcon = payload["largeIconId"] as String
    }
    if (payload["placeHolderIcon"] != null) {
      option.placeHolderIcon = payload["placeHolderIcon"] as String
    }
    if (payload["smallIconId"] != null) {
      option.smallIcon = payload["smallIconId"] as String
    }
    if (payload["transparentIconBgColor"] != null) {
      option.transparentIconBgColor = payload["transparentIconBgColor"] as String
    }
      smartPush.setNotificationOptions(option)
    }

  private fun getIconResourceId(iconName: String) : Int {
    return context.getResources().getIdentifier(iconName, "drawable", context.getPackageName())
  }

  companion object{

    //App base context
    lateinit var context: Context

    fun initializePlugin(application: Application) {
      context = application.applicationContext
    }

  }

}
