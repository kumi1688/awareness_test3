import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pedometer/pedometer.dart';
import 'package:http/http.dart' as http;

import '../state/step.dart';

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
    _startListening();
    Timer.periodic(Duration(seconds: 30), (timer) {
//      _sendStepData();
    });
  }


  void _onData(int stepCountValue) async {
    if(_initialStepCountValue == -1){
      setState(() => _initialStepCountValue = stepCountValue);
    }
//    final _stepState = Provider.of<stepState>(context);
//    _stepState.step = stepCountValue - _initialStepCountValue;
    setState(() => _stepCountValue = stepCountValue - _initialStepCountValue);
  }

  void _startListening() {
    _pedometer = new Pedometer();
    _subscription = _pedometer.pedometerStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
  }

  _sendStepData() async {
      String url = 'http://210.107.206.172:3000/step';
      var data = {
        "step": _stepCountValue.toString(),
        "time": new DateTime.now().toString()
      };
      await http.post(url, body: data);
      setState(() {
        _initialStepCountValue += _stepCountValue;
        _stepCountValue = 0;
      });
  }

  _checkPermission() async {
    await Permission.activityRecognition.request();
  }

  void _onDone() => print("Finished pedometer tracking");

  void _onError(error) => print("Flutter Pedometer Error: $error");

  void stopListening() {
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            title: Text('걸음 수 화면')
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('걸음수 : ${_stepCountValue}', style: TextStyle(fontSize: 20),),
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
          onPressed: _sendStepData,
          child: Icon(Icons.search)
      ),

    );
  }

  _backToMainPage(BuildContext context) => Navigator.pop(context);


}