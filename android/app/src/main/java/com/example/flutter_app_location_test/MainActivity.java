package com.example.flutter_app_location_test;

import androidx.annotation.NonNull;

import com.example.flutter_app_location_test.user_activity.UserDetectiveActivity;
import com.google.android.gms.awareness.Awareness;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import com.google.android.gms.awareness.snapshot.DetectedActivityResponse;
import com.google.android.gms.location.ActivityRecognitionResult;
import com.google.android.gms.location.DetectedActivity;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;

public class MainActivity extends FlutterActivity {
    private String _userActivity;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        final MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), "com.example.flutter_location_test");
        channel.setMethodCallHandler(handler);
    }

    private MethodChannel.MethodCallHandler handler = (methodCall, result) -> {
        if (methodCall.method.equals("getUserDetectiveActivity")) {
            getUserState(result);
        }  else {
            result.notImplemented();
        }
    };

    private void getUserState(MethodChannel.Result result) {
        Awareness.getSnapshotClient(this).getDetectedActivity()
                .addOnSuccessListener(new OnSuccessListener<DetectedActivityResponse>() {
                    @Override
                    public void onSuccess(DetectedActivityResponse dar) {
                        ActivityRecognitionResult arr = dar.getActivityRecognitionResult();
                        DetectedActivity probableActivity = arr.getMostProbableActivity();

                        int confidence = probableActivity.getConfidence();
                        int type = probableActivity.getType();

                        UserDetectiveActivity userDetectiveActivity = new UserDetectiveActivity(type, confidence);
                        _userActivity = "확률 : " + userDetectiveActivity.getConfidence() + "%" + ", "
                                + "활동 : " + userDetectiveActivity.getType();
                        result.success(_userActivity);
                    }
                })
                .addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        e.printStackTrace();
//                        _userActivity = "사용자 상태 가져올 수 없음";
                        result.success(_userActivity);
                    }
                });
    }
}
