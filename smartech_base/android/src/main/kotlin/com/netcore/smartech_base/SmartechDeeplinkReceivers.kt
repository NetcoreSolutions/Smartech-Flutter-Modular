package com.netcore.smartech_base

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import com.netcore.android.SMTBundleKeys
import org.json.JSONObject
import org.json.JSONArray

class SmartechDeeplinkReceivers : BroadcastReceiver() {

    companion object{
        var deeplinkReceiverCallBack:((map: Map<String, Any>)->Unit)? = null
    }

    override fun onReceive(p0: Context?, p1: Intent?) {
        val bundleExtra: Bundle? = p1?.extras
        var smtDeeplinkSource:String? = null
        var smtDeeplink:String? = null
        var smtPayload:Map<String, Any>? = null
        var smtCustomPayload:Map<String, Any>? = null
        var smtPayloadValue: String? = null
        var smtCustomPayloadValue: String? = null

        if (bundleExtra != null) {
            if (bundleExtra.containsKey(SMTBundleKeys.SMT_KEY_DEEPLINK_SOURCE)) {
                val smtDeeplinkSourceValue: String? = bundleExtra.getString(SMTBundleKeys.SMT_KEY_DEEPLINK_SOURCE)
                smtDeeplinkSource = smtDeeplinkSourceValue
            } else {
                Log.v("Activity", "does not have deeplink source.")
            }

            if (bundleExtra.containsKey(SMTBundleKeys.SMT_KEY_DEEPLINK)) {
                val smtDeeplinkvalue: String? = bundleExtra.getString(SMTBundleKeys.SMT_KEY_DEEPLINK)
                smtDeeplink = smtDeeplinkvalue
            } else {
                Log.v("Activity", "does not have deeplink path.")
            }

            try {
                if (bundleExtra.containsKey(SMTBundleKeys.SMT_KEY_PAYLOAD)) {
                    smtPayloadValue = bundleExtra.getString(SMTBundleKeys.SMT_KEY_PAYLOAD)
                    if(smtPayloadValue != null){
                        Log.v("smtPayload value :: ", "" + smtPayloadValue)
                        val jsonObject = JSONObject(smtPayloadValue)
                        smtPayload = jsonToMap(jsonObject)
                    }
                } else {
                    Log.v("Activity", "does not have smt payload.")
                }
              } catch (e: Exception) {
                e.printStackTrace()
            }

            try {
                if (bundleExtra.containsKey(SMTBundleKeys.SMT_KEY_CUSTOM_PAYLOAD)) {
                    smtCustomPayloadValue = bundleExtra.getString(SMTBundleKeys.SMT_KEY_CUSTOM_PAYLOAD)
                    if(smtCustomPayloadValue != null){
                        Log.v("smtCustomPayload value :: ", "" + smtCustomPayloadValue)
                        val jsonObject = JSONObject(smtCustomPayloadValue)
                        smtCustomPayload = jsonToMap(jsonObject)
                    }
                } else {
                    Log.v("Activity", "does not have custom payload.")
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }

             val map = HashMap<String, Any>()
             if(smtDeeplink != null){
                 map["smtDeeplink"] = smtDeeplink
             }
             if(smtCustomPayload != null){
                 map["smtCustomPayload"] = smtCustomPayload
             }
             if(smtDeeplinkSource != null){
                 map["smtDeeplinkSource"] = smtDeeplinkSource
             }
             if(smtPayload != null){
                 map["smtPayload"] = smtPayload
             }

            SmartechBasePlugin.context
                .getSharedPreferences("Deeplink_action", Context.MODE_PRIVATE)
                .edit()
                .putString("smtDeeplinkSource", smtDeeplinkSource)
                .putString("smtDeeplink", smtDeeplink)
                .putString("smtPayload", smtPayloadValue)
                .putString("smtCustomPayload", smtCustomPayloadValue)
                .apply()
            Log.v("deeplinkReceiverCallBack called", "onHandleDeeplinkAction")
            deeplinkReceiverCallBack?.invoke(map)
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
}