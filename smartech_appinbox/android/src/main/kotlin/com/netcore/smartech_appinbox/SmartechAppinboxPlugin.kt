package com.netcore.smartech_appinbox
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.netcore.android.smartechappinbox.SmartechAppInbox
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import com.netcore.android.smartechappinbox.utility.*
import com.netcore.android.smartechappinbox.network.model.SMTInboxMessageData;
import com.netcore.android.smartechappinbox.utility.SMTAppInboxMessageType;
import com.netcore.android.smartechappinbox.utility.SMTAppInboxRequestBuilder;
import com.netcore.android.smartechappinbox.network.listeners.SMTInboxCallback
import android.content.Context
import android.app.Application
import java.lang.ref.WeakReference
import android.app.Activity
import com.google.gson.Gson
import android.util.Log


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
      "getAppInboxMessages" -> {
        val messages = smartAppInbox.getAppInboxMessages(SMTAppInboxMessageType.INBOX_MESSAGE)
        result.success(Gson().toJson(messages))
      }
      "getAppInboxCategoryList" -> {
        val categoryList = smartAppInbox.getAppInboxCategoryList()
        result.success(Gson().toJson(categoryList))
      }
      "getAppInboxCategoryWiseMessageList" -> {
        var categoryList = call.argument<List<String>>("group_id") as ArrayList<String>
        Log.d("categoryList", "" + categoryList)
        categoryList?.let{
          val categoryFilteredData = smartAppInbox.getAppInboxMessages(categoryList)
          Log.d("categoryFilteredData", "" + categoryFilteredData)
          result.success(Gson().toJson(categoryFilteredData))
        }
      }
     "markMessageAsDismissed" -> {
        var trId = call.argument<String>("trid") as String
        Log.d("trid", "" + trId)
        val appInboxMessage = smartAppInbox.getAppInboxMessageById(trId)
          appInboxMessage?.let{
            smartAppInbox.markMessageAsDismissed(appInboxMessage)
          }        
        result.success(null)
      } 
      "markMessageAsClicked" -> {
        var trId = call.argument<String>("trid") as String
        var deeplink = call.argument<String>("deeplink") as String
        Log.d("trid", "" + trId)
        Log.d("deeplink", "" + deeplink)
        val appInboxMessage = smartAppInbox.getAppInboxMessageById(trId)
          appInboxMessage?.let{
            smartAppInbox.markMessageAsClicked(deeplink, appInboxMessage)
          }        
        result.success(null)
      } 
      "markMessageAsViewed" -> {
        var trId = call.argument<String>("trid") as String
        Log.d("trid", "" + trId)
        val appInboxMessage = smartAppInbox.getAppInboxMessageById(trId)
          appInboxMessage?.let{
            smartAppInbox.markMessageAsViewed(appInboxMessage)
          }        
        result.success(null)
      } 
      "getAppInboxMessagesByApiCall" -> {
        val builder = SMTAppInboxRequestBuilder.Builder(SMTInboxDataType.ALL).setCallback(object : SMTInboxCallback {
          override fun onInboxFail() {
          }
          
          override fun onInboxProgress() {
          }
          
          override fun onInboxSuccess(messages: MutableList<SMTInboxMessageData>?) {
              result.success(Gson().toJson(messages))
          }
          }).setLimit(10).build()
        smartAppInbox.getAppInboxMessages(builder)    
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  /** private fun markMessageAsDismissed(payload: String) {
    val appInboxMessage = smartAppInbox.getAppInboxMessageById(payload)
    appInboxMessage?.let{
      smartAppInbox.markMessageAsDismissed(appInboxMessage)
    }
  } */

  // private fun getAppInboxMessagesByCategoryApiCall() {
  //     val builder = SMTAppInboxRequestBuilder.Builder(SMTInboxDataType.ALL)
  //     builder.setCallback(object : SMTInboxCallback {
  //         override fun onInboxFail() {
  //           Log.d("failed", "failed")
  //         }

  //         override fun onInboxProgress() {
  //           Log.d("progress", "progress")
  //         }

  //         override fun onInboxSuccess(messages: MutableList<SMTInboxMessageData>?) {
  //           Log.d("success", "success")
  //         }
  //     }) 
  //     smartAppInbox.getAppInboxMessages(builder)
  // }

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
