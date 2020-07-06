import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';

class ActivityRecognitionPage extends StatefulWidget {
  @override
  _ActivityRecognitionPageState createState() => _ActivityRecognitionPageState();
}

class _ActivityRecognitionPageState extends State<ActivityRecognitionPage> {
  String _userDetectiveActivity = '';
  static const MethodChannel _channel =
  const MethodChannel('com.example.flutter_location_test');

  List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];

  Future<void> getUserDetectiveActivity() async {
    final String uda = await _channel.invokeMethod('getUserDetectiveActivity');
    print(uda);
    setState(()=>_userDetectiveActivity = uda);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('상태 추적 화면'),
        ),
        body: Center(
          child: Text(_userDetectiveActivity),
        ) ,
      floatingActionButton: FloatingActionButton(
        onPressed: getUserDetectiveActivity, //버튼이 눌리면 스캔 ON/OFF 동작
        child: Icon(Icons.search)
      ),


    );
  }

  _backToMainPage(BuildContext context) => Navigator.pop(context);

}
