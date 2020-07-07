import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pedometer/pedometer.dart';
import 'package:http/http.dart' as http;

import '../state/Location.dart';

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

  _sendStepData() async {
      String url = 'http://15.164.219.251:3000/step';
      var response = await http.post(url, body: {"step": _stepCountValue.toString()});
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
//    Timer.periodic(new Duration(seconds: 5), (timer) async {
//      String url = 'http://15.164.219.251:3000/step';
//      var response = await http.post(url, body: {"step": _stepCountValue.toString()});
//      print('Response status: ${response.statusCode}');
//      print('Response body: ${response.body}');
//    });
  }

  _getTestData() async {
    String url = 'http://15.164.219.251:3000/step';
    var response = await http.get(url);
    print('status = ${response.statusCode}');
    print('body = ${response.body}');
  }



  void _onDone() => print("Finished pedometer tracking");

  void _onError(error) => print("Flutter Pedometer Error: $error");

  void stopListening() {
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {

    void _onData(int stepCountValue) async {
      if(_initialStepCountValue == -1){
        setState(() => _initialStepCountValue = stepCountValue);
      }
      final Location location = Provider.of<Location>(context);
      location.step = stepCountValue;
      setState(() => _stepCountValue = stepCountValue - _initialStepCountValue);
    }

    void startListening() {
      _pedometer = new Pedometer();
      _subscription = _pedometer.pedometerStream.listen(_onData,
          onError: _onError, onDone: _onDone, cancelOnError: true);
    }

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