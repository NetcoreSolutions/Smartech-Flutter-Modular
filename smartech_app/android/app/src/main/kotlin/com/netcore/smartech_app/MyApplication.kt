package com.netcore.smartech_app

import android.util.Log
import com.netcore.android.Smartech
import com.netcore.smartech_base.SmartechBasePlugin
import io.flutter.app.FlutterApplication
import java.lang.ref.WeakReference

class MyApplication: FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        Log.d("MyApplication","onCreate")

        //Initialize Smartech Sdk
        Smartech.getInstance(WeakReference(applicationContext)).initializeSdk(this)
        Smartech.getInstance(WeakReference(applicationContext)).setDebugLevel(9)
        Smartech.getInstance(WeakReference(applicationContext)).trackAppInstallUpdateBySmartech()

        //Initialize Smartech Flutter Base Plugin
        SmartechBasePlugin.initializePlugin(this)

    }

    override fun onTerminate() {
        super.onTerminate()
        Log.d("onTerminate","onTerminate")
    }
}