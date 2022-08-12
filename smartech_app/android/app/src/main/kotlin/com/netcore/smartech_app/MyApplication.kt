package com.netcore.smartech_app

import android.util.Log
import com.netcore.android.Smartech
import com.netcore.android.smartechpush.SmartPush
import com.netcore.android.smartechpush.notification.SMTNotificationListener
import com.netcore.smartech_base.SmartechBasePlugin
import com.netcore.smartech_push.SmartechPushPlugin
import com.netcore.smartech_appinbox.SmartechAppinboxPlugin
import io.flutter.app.FlutterApplication
import java.lang.ref.WeakReference



class MyApplication: FlutterApplication(), SMTNotificationListener {
    override fun onCreate() {
        super.onCreate()
        Log.d("MyApplication","onCreate")

        //Initialize Smartech Sdk
        Smartech.getInstance(WeakReference(applicationContext)).initializeSdk(this)
        Smartech.getInstance(WeakReference(applicationContext)).setDebugLevel(9)
        Smartech.getInstance(WeakReference(applicationContext)).trackAppInstallUpdateBySmartech()

        //Initialize Flutter Smartech Base Plugin
        SmartechBasePlugin.initializePlugin(this)
      

        //Initialize Flutter Smartech Push Plugin
        SmartechPushPlugin.initializePlugin(this)

         //Initialize Flutter Smartech AppInbox Plugin
        SmartechAppinboxPlugin.initializePlugin(this)

        //Add SmartPush Notification Listener
        SmartPush.getInstance(WeakReference(SmartechPushPlugin.context)).setSMTNotificationListener(this)

    }

    override fun onTerminate() {
        super.onTerminate()
        Log.d("onTerminate","onTerminate")
    }

    //implement override Smartech Notification method
    override fun getSmartechNotifications(payload: String, source: Int) {
        SmartPush.getInstance(WeakReference(SmartechPushPlugin.context)).renderNotification(payload, source)
    }
}