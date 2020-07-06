import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';

class ActivityRecognitionPage extends StatefulWidget {
  @override
  _ActivityRecognitionPageState createState() => _ActivityRecognitionPageState();
}

class _ActivityRecognitionPageState extends State<ActivityRecognitionPage> {
  StreamSubscription _subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: const Text('상태 추적 화면'),
        ),
        body: new Center(
          child: StreamBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Activity act = snapshot.data;
                return Text("Your phone is to ${act.confidence}% ${act.type}!");
              }
              return Text("No activity detected.");
            },
            stream: ActivityRecognition.activityUpdates(),
          ),
        ),
    );
  }

  _backToMainPage(BuildContext context) => Navigator.pop(context);

}
