package com.example.sms

import android.telephony.SmsManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.sms/sendSMS"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendSMS") {
                val phoneNumber = call.argument<String>("phoneNumber")
                val message = call.argument<String>("message")
                if (phoneNumber != null && message != null) {
                    sendSms(phoneNumber, message)
                    result.success(null)
                } else {
                    result.error("NULL_ARGUMENTS", "Phone number or message is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun sendSms(phoneNumber: String, message: String) {
        try {
            val smsManager = SmsManager.getDefault()
            smsManager.sendTextMessage(phoneNumber, null, message, null, null)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
