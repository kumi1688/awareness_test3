import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:light/light.dart';

import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const String MAIN_PAGE = '/';
  static const String LOCATION_PAGE = '/location';
  static const String ACCELATOR_PAGE = '/accelator';
  static const String STEP_PAGE = '/step';
  static const String LIGHT_PAGE = '/light';
  static const String ACTIVITY_RECOGNITION_PAGE = '/activity_recognition';
  static const String BLUETOOTH = '/bluetooth';
  static const String NETWORK = '/network';

  static const String SERVER_URL = 'http://210.107.206.172:3000/general';

  Position _position;
  List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];

  Pedometer _pedometer;
  int _stepCountValue = 0;
  int _initialStepCountValue = -1;

  Light _light;
  int _lightValue;

  List<dynamic>_userDetectiveActivities = [];
  static const MethodChannel _methodChannel =  const MethodChannel('com.example.flutter_location_test');

  @override
  void initState(){
    super.initState();
    _checkPermission();
    _getCurrentPosition();
    _startListening();
    Timer.periodic(Duration(seconds: 10), (timer) {
      _sendData();
      _initStep();
    });
  }

  _checkPermission() async {
    await Permission.activityRecognition.request();
    await Permission.location.request();
  }

  _getCurrentPosition() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _position = position;
    });
  }

  Future<void> _getUserDetectiveActivity() async {
    final List<dynamic> udas = await _methodChannel.invokeMethod('getUserDetectiveActivity');
    setState(()=> _userDetectiveActivities = udas);
  }

  _sendData() async {
    if(_position == null){
      _getCurrentPosition();
    }
    _getCurrentPosition();
    _getUserDetectiveActivity();

    var data = {
      "latitude": _position.latitude.toString(),
      "longitude": _position.longitude.toString(),
      "step": _stepCountValue.toString(),
      "light": _lightValue.toString(),
      "activity": jsonEncode(_userDetectiveActivities),
      "time": new DateTime.now().toString()
    };
    http.post(SERVER_URL, body: data);
  }


  void _onData_step(int stepCountValue) async {
    if(_initialStepCountValue == -1){
      setState(() => _initialStepCountValue = stepCountValue);
    }
    setState(() => _stepCountValue = stepCountValue - _initialStepCountValue);
  }


  void _onData_light(int luxValue) async {
    setState(()=>_lightValue = luxValue);
  }

  void _startListening() {
    _pedometer = new Pedometer();
    _light = new Light();
    _streamSubscriptions.add(_pedometer.pedometerStream.listen(_onData_step,
        onError: _onError, onDone: _onDone, cancelOnError: true));
    _streamSubscriptions.add(_light.lightSensorStream.listen(_onData_light,
        onError: _onError, onDone: _onDone, cancelOnError: true));
  }

  void _onDone() => print("Finished");

  void _onError(error) => print("Flutter Error: $error");

  void _stopListening() {
    _streamSubscriptions.forEach((subscription) {subscription.cancel();});
  }

  _initStep() {
    setState(() {
      _initialStepCountValue += _stepCountValue;
      _stepCountValue = 0;
    });
  }



  _showNextPage(BuildContext context, String destination) => Navigator.pushNamed(context, destination);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('메인 화면'),
        ),
        body: Center(
          child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => _showNextPage(context, LOCATION_PAGE),
                  child: Text('위치 화면으로 넘어가기'),
                ),
                RaisedButton(
                  onPressed: () => _showNextPage(context, ACCELATOR_PAGE),
                  child: Text('가속도 화면으로 넘어가기'),
                ),
                RaisedButton(
                  onPressed: () => _showNextPage(context, STEP_PAGE),
                  child: Text('걸음수 화면으로 넘어가기'),
                ),
                RaisedButton(
                  onPressed: () => _showNextPage(context, LIGHT_PAGE),
                  child: Text('조도 화면으로 넘어가기'),
                ),
                RaisedButton(
                  onPressed: () => _showNextPage(context, ACTIVITY_RECOGNITION_PAGE),
                  child: Text('상태 추적 화면으로 넘어가기'),
                ),
                RaisedButton(
                  onPressed: () => _showNextPage(context, BLUETOOTH),
                  child: Text('블루투스 화면으로 넘어가기'),
                ),
                RaisedButton(
                  onPressed: () => _showNextPage(context, NETWORK),
                  child: Text('네트워크 화면으로 넘어가기'),
                ),
              ],
            )
        )

    );
  }


}