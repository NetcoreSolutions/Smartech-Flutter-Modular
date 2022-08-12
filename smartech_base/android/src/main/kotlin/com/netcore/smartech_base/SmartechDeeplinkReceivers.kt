package com.netcore.smartech_base

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import com.netcore.android.SMTBundleKeys


class SmartechDeeplinkReceivers : BroadcastReceiver() {

    companion object{
        var deeplinkReceiverCallBack:((link: String?, payload: String?)->Unit)? = null
    }

    override fun onReceive(p0: Context?, p1: Intent?) {
        val bundleExtra: Bundle? = p1?.extras
        var link:String? = null
        var payload:String? = null

        if (bundleExtra != null) {

            if (bundleExtra.containsKey(SMTBundleKeys.SMT_BUNDLE_KEY_CLICK_DEEPLINK)) {
                val deepLinkvalue: String? = bundleExtra.getString(SMTBundleKeys.SMT_BUNDLE_KEY_CLICK_DEEPLINK)
                link = deepLinkvalue
            } else {
                Log.v("Activity", "does not have deeplink path.")
            }
            if (bundleExtra.containsKey(SMTBundleKeys.SMT_BUNDLE_KEY_CLICK_CUSTOM_PAYLOAD)) {
                val customPayloadvalue: String? = bundleExtra.getString(SMTBundleKeys.SMT_BUNDLE_KEY_CLICK_CUSTOM_PAYLOAD)
                payload = customPayloadvalue
            } else {
                Log.v("Activity", "does not have custom payload.")
            }

            SmartechBasePlugin.context
                .getSharedPreferences("Deeplink_action", Context.MODE_PRIVATE)
                .edit()
                .putString("deepLinkUrl", link)
                .putString("payload", payload)
                .apply()

            deeplinkReceiverCallBack?.invoke(link, payload)
        }
    }

}