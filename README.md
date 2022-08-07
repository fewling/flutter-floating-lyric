# Before Build:

## 1. Modify SystemAlertWindow package file for transparent background

Details: https://github.com/pvsvamsi/SystemAlertWindow/issues/94#issuecomment-1186072072 

<br>

## 2. Modify  SystemAlertWindow package file for WRAP_CONTENT height

Find file: `flutter\.pub-cache\hosted\pub.dartlang.org\system_alert_window-1.1.2\android\src\main\java\in\jvapps\system_alert_window\services\WindowServiceNew.java`

Find functions below: 

    private WindowManager.LayoutParams getLayoutParams() {...}

    private void updateWindow(HashMap<String, Object> paramsMap) {...}

Change line from:
    
    params.height = (windowHeight == 0) ? android.view.WindowManager.LayoutParams.WRAP_CONTENT : Commons.getPixelsFromDp(mContext, windowHeight);

to:

    params.height = android.view.WindowManager.LayoutParams.WRAP_CONTENT;