package com.rate.business

import android.app.Activity
import android.content.Intent
import android.os.Build
import android.provider.ContactsContract
import android.provider.Settings
import android.Manifest
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity() {
    private val DEVICE_INFO_CHANNEL = "com.example.deviceInfo"
    private val CONTACT_PICKER_CHANNEL = "com.example.contacts/picker"
    private val REQUEST_PHONE_STATE = 1
    private val CONTACT_PICKER_REQUEST = 1001

    private var resultCallback: MethodChannel.Result? = null


    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Device Identifier Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEVICE_INFO_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getDeviceIdentifier") {
                if (Build.VERSION.SDK_INT in Build.VERSION_CODES.O..Build.VERSION_CODES.P) {
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
                        result.success(getDeviceIdentifier())
                    } else {
                        ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.READ_PHONE_STATE), REQUEST_PHONE_STATE)
                        result.success("Permission required")
                    }
                } else {
                    result.success(getDeviceIdentifier())
                }
            } else {
                result.notImplemented()
            }
        }

        // Contact Picker Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CONTACT_PICKER_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "pickContact") {
                pickContact()
                resultCallback = result
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getDeviceIdentifier(): String {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID)
        } else {
            try {
                Build.getSerial()
            } catch (e: SecurityException) {
                "Permission denied"
            }
        }
    }

    private fun pickContact() {
        val intent = Intent(Intent.ACTION_PICK, ContactsContract.Contacts.CONTENT_URI)
        startActivityForResult(intent, CONTACT_PICKER_REQUEST)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == CONTACT_PICKER_REQUEST && resultCode == Activity.RESULT_OK) {
            val contactUri = data?.data ?: return
            val cursor = contentResolver.query(contactUri, null, null, null, null)
            cursor?.moveToFirst()
            val nameIndex = cursor?.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME)
            val contactName = nameIndex?.let { cursor.getString(it) }
            cursor?.close()
            resultCallback?.success(contactName)
        } else if (requestCode == CONTACT_PICKER_REQUEST) {
            resultCallback?.success(null)
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        if (requestCode == REQUEST_PHONE_STATE) {
            if ((grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED)) {
                flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                    MethodChannel(messenger, DEVICE_INFO_CHANNEL).invokeMethod("getDeviceIdentifier", getDeviceIdentifier())
                }
            }
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }
}
