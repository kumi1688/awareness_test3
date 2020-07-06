import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors/sensors.dart';

class AccelatorPage extends StatefulWidget {
  @override
  _Accelerometer createState() => _Accelerometer();
}

class _Accelerometer extends State<AccelatorPage> {
  List<double> _accelerometerValues;
  List<double> _userAccelerometerValues;
  List<double> _gyroscopeValues;

  List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPermission();
    _requestPermission();
  }

  _checkPermission() async {
    await Permission.activityRecognition.request();
  }

  _requestPermission() {
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer =
    _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> gyroscope =
    _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        ?.toList();

    return Scaffold(
        appBar: AppBar(
            title: Text('가속도 화면')
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Text('acc: ${accelerometer}', style: TextStyle(fontSize: 25),),
              Text('userAcc: ${userAccelerometer}', style: TextStyle(fontSize: 25),),
                Text('gyro: ${gyroscope}', style: TextStyle(fontSize: 25)),
            ],
          ),
        )
    );
  }

  _backToMainPage(BuildContext context) => Navigator.pop(context);
}