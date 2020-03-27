package com.example.example_app

    import android.annotation.SuppressLint
    import android.util.Log
    import com.google.firebase.messaging.FirebaseMessagingService
    import com.google.firebase.messaging.RemoteMessage
    import android.app.NotificationManager
    import android.media.RingtoneManager
    import android.app.PendingIntent
    import android.content.Context
    import android.content.Intent
    import androidx.core.app.NotificationCompat
    import com.example.example_app.MainActivity    
    import com.example.example_app.R
    import com.google.firebase.iid.InstanceIdResult
    import com.google.android.gms.tasks.OnSuccessListener
    import com.google.firebase.iid.FirebaseInstanceId


    class MyFirebaseMessagingService : FirebaseMessagingService(){

        val TAG = "FirebaseMessagingService"

        override fun onNewToken(token: String) {
            Log.d("New_Token", token)
        }
        @SuppressLint("LongLogTag")

        override fun onMessageReceived(remoteMessage: RemoteMessage) {
            super.onMessageReceived(remoteMessage)

            if (remoteMessage.notification != null) {
                sendNotification(remoteMessage)
            }
        }

    private fun sendNotification(remoteMessage: RemoteMessage) {
        val intent = Intent(this, MainActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)

        val pendingIntent = PendingIntent.getActivity(this@MyFirebaseMessagingService, 0, intent, PendingIntent.FLAG_ONE_SHOT)
            val soundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
            val notificationBuilder = NotificationCompat.Builder(this@MyFirebaseMessagingService, "Notification")
                .setSmallIcon(com.example.example_app.R.mipmap.ic_launcher)
                .setContentTitle("FCM Message")
                .setContentText(remoteMessage.notification?.body)
                .setAutoCancel(true)
                .setSound(soundUri)
                .setContentIntent(pendingIntent)

            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.notify(0, notificationBuilder.build())

        }
        }