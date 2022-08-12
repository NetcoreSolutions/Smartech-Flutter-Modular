package com.netcore.smartech_app

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.util.Log
import com.netcore.smartech_base.SmartechDeeplinkReceivers

class MainActivity: FlutterActivity() {
      override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        SmartechDeeplinkReceivers().onReceive(this, intent)
        
        Log.d("MainActivity", "MainActivity open2")

    }
}
