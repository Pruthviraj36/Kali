package com.example.stegonotifier

import android.Manifest
import android.app.*
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.*
import android.provider.Settings
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

class MainActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Ask user to allow "All Files Access"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            if (!Environment.isExternalStorageManager()) {
                val intent = Intent(Settings.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION)
                intent.data = Uri.parse("package:$packageName")
                startActivity(intent)
            }
        }

        // Ask for POST_NOTIFICATIONS permission
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS)
            != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                101
            )
        }

        // Start watching WhatsApp image folder
        startFileObserver()
    }

    private fun startFileObserver() {
        val path = "/storage/emulated/0/WhatsApp/Media/WhatsApp Images/"
        val observer = object : FileObserver(path, CREATE) {
            override fun onEvent(event: Int, file: String?) {
                if (file != null && file.endsWith(".jpg", true)) {
                    val fullPath = "$path$file"
                    Log.d("FileObserver", "New image: $fullPath")
                    showNotification("New Image", "📢 I am here")
                }
            }
        }
        observer.startWatching()
    }

    private fun showNotification(title: String, text: String) {
        val channelId = "stego_alerts"
        val notificationManager = getSystemService(NotificationManager::class.java)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(channelId, "Stego Alerts", NotificationManager.IMPORTANCE_HIGH)
            notificationManager.createNotificationChannel(channel)
        }

        val notification = Notification.Builder(this, channelId)
            .setContentTitle(title)
            .setContentText(text)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .build()

        notificationManager.notify(1, notification)
    }
}
