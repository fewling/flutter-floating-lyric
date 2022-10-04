# Before Build:

## 1. Modify SystemAlertWindow package file for transparent background

Details: https://github.com/pvsvamsi/SystemAlertWindow/issues/94#issuecomment-1186072072 
    As of version 1.1.2, I made the background transparent by directly modifing the package file (just one line).

    Look into your flutter sdk directory and find the file:
    flutter\.pub-cache\hosted\pub.dartlang.org\system_alert_window-1.1.2\android\src\main\java\in\jvapps\system_alert_window\services\WindowServiceNew.java.

    You should be able to find a function, private void setWindowView(...), and remove/comment the line windowView.setBackgroundColor(Color.WHITE);.

    Then in flutter, header, body and/or footer widget(s) should contains a decoration property where you can set the background transparent as well.

<br>

## 2. Modify  SystemAlertWindow package file for WRAP_CONTENT height

Find file: `flutter\.pub-cache\hosted\pub.dartlang.org\system_alert_window-1.1.2\android\src\main\java\in\jvapps\system_alert_window\services\WindowServiceNew.java`

Find functions below: 
```java
    private WindowManager.LayoutParams getLayoutParams() {...}

    private void updateWindow(HashMap<String, Object> paramsMap) {...}
```
Change line from:
```java
    params.height = (windowHeight == 0) ? android.view.WindowManager.LayoutParams.WRAP_CONTENT : Commons.getPixelsFromDp(mContext, windowHeight);
```
to:
```java
    params.height = android.view.WindowManager.LayoutParams.WRAP_CONTENT;
```

<br>

## 3. Removing the nofication 

Find file: `flutter\.pub-cache\hosted\pub.dartlang.org\system_alert_window-1.1.2\android\src\main\java\in\jvapps\system_alert_window\services\WindowServiceNew.java`

Change `onCreate()` as below:
```java
    public void onCreate() {
        mContext = this;
        // createNotificationChannel();
        // Intent notificationIntent = new Intent(this, SystemAlertWindowPlugin.class);
        // PendingIntent pendingIntent;
        // if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
        //     pendingIntent = PendingIntent.getActivity(this,
        //             0, notificationIntent, PendingIntent.FLAG_MUTABLE);
        // } else {
        //     pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0);
        // }
        // Notification notification = new NotificationCompat.Builder(this, CHANNEL_ID)
        //         .setContentTitle("Overlay window service is running")
        //         .setSmallIcon(R.drawable.ic_desktop_windows_black_24dp)
        //         .setContentIntent(pendingIntent)
        //         .build();
        // startForeground(NOTIFICATION_ID, notification);
    }
```

Change `onDestroy()` as below:
```java
    public void onDestroy() {
        //Toast.makeText(this, "service done", Toast.LENGTH_SHORT).show();
        LogUtils.getInstance().d(TAG, "Destroying the overlay window service");
        // NotificationManager notificationManager = (NotificationManager) getApplicationContext().getSystemService(Context.NOTIFICATION_SERVICE);
        // assert notificationManager != null;
        // notificationManager.cancel(NOTIFICATION_ID);
    }
```
