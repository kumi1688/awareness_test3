import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pedometer/pedometer.dart';

class StepPage extends StatefulWidget {
  @override
  _StepPageState createState() => _StepPageState();
}

class _StepPageState extends State<StepPage> {
  Pedometer _pedometer;
  int _stepCountValue = 0;
  int _initialStepCountValue = -1;

  StreamSubscription _subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPermission();
    startListening();
  }

  _checkPermission() async {
    await Permission.activityRecognition.request();
  }

  void onData(int stepCountValue) {
    print(stepCountValue);
  }

  void startListening() {
    _pedometer = new Pedometer();
    _subscription = _pedometer.pedometerStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
  }

  void stopListening() {
    _subscription.cancel();
  }

  void _onData(int stepCountValue) async {
    if(_initialStepCountValue == -1){
      setState(() => _initialStepCountValue = stepCountValue);
    }
    setState(() => _stepCountValue = stepCountValue - _initialStepCountValue);
  }

  void _onDone() => print("Finished pedometer tracking");

  void _onError(error) => print("Flutter Pedometer Error: $error");

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
            title: Text('가속도 화면')
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('걸음수 : ${_stepCountValue}', style: TextStyle(fontSize: 20),),
            ],
          ),
        )
    );
  }

  _backToMainPage(BuildContext context) => Navigator.pop(context);


}