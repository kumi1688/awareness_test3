import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:http/http.dart' as http;

import 'dart:io' show Platform;

class ActivityRecognitionPage extends StatefulWidget {
  @override
  _ActivityRecognitionPageState createState() => _ActivityRecognitionPageState();
}

class _ActivityRecognitionPageState extends State<ActivityRecognitionPage> {
  List<dynamic>_userDetectiveActivities = [];
  String _userDetectiveActivity = '';
  int _updateCount = 0;
  Timer _everySecond;
  static const MethodChannel _methodChannel =  const MethodChannel('com.example.flutter_location_test');
  static const EventChannel _eventChannel = const EventChannel('com.example.flutter_location_test');

  List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];

  Future<void> getUserDetectiveActivity() async {
//    final String uda = await _methodChannel.invokeMethod('getUserDetectiveActivity');
//    setState(()=>_userDetectiveActivity = uda == null ? '상태 가져올 수 없음' : uda);
    final List<dynamic> udas = await _methodChannel.invokeMethod('getUserDetectiveActivity');
    setState(()=>_userDetectiveActivities = udas);
//    _sendActivityData();
  }



  _sendActivityData() async {
    String url = 'http://210.107.206.172:3000/activity';
    var data = {
      "activity": jsonEncode(_userDetectiveActivities),
      "time": new DateTime.now().toString()
    };
    print(jsonEncode(data));
    http.post(url, body: data);
  }

  _checkUserDetectiveActivity() {
    _everySecond = Timer.periodic(Duration(seconds: 10), (timer) {
//      getUserDetectiveActivity();
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkUserDetectiveActivity();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('상태 추적 화면'),
        ),
        body: Center(
          child: _list()
        ) ,

      floatingActionButton: FloatingActionButton(
        onPressed: getUserDetectiveActivity,
        child: Icon(Icons.search)
      ),
    );
  }

  _list(){
    return ListView.builder(
        itemCount: _userDetectiveActivities.length,
        itemBuilder: (BuildContext context, int i){
          return ListTile(
            title: Text('${_userDetectiveActivities[i]}'),
          );
        }
    );
  }

  _backToMainPage(BuildContext context) => Navigator.pop(context);
}

class UserDetectiveActivity {
  String _type;
  int _confidence;

   static const int IN_VEHICLE = 0;
   static const int ON_BICYCLE = 1;
   static const int ON_FOOT = 2;
   static const int STILL = 3;
   static const int UNKNOWN = 4;
   static const int TILTING = 5;
   static const int WALKING = 7;
   static const int RUNNING = 8;

   UserDetectiveActivity(this._type, this._confidence);

   String _convertType(int type){
    switch(type){
      case IN_VEHICLE:    return "IN_VEHICLE";
      case ON_BICYCLE:    return "ON_BICYCLE";
      case ON_FOOT:       return "ON_FOOT";
      case STILL:         return "STILL";
      case TILTING:       return "TILTING";
      case WALKING:       return "WALKING";
      case RUNNING:       return "RUNNING";
      default:            return "UNKNOWN";
    }
  }

   String getType(){
    return this._type;
  }

   int getConfidence(){
    return this._confidence;
  }
}