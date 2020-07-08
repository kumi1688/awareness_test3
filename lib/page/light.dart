import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:light/light.dart';
import 'package:http/http.dart' as http;

class LightPage extends StatefulWidget {
  @override
  _LightPageState createState() => _LightPageState();
}

class _LightPageState extends State<LightPage> {
  Light _light;
  int _lightValue;
  StreamSubscription _subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _checkPermission();
    startListening();
    Timer.periodic(Duration(minutes: 60), (timer) {
//      _sendLightData();
    });
  }

  _checkPermission() async {
    await Permission.activityRecognition.request();
  }

  _sendLightData() async {
    String url = 'http://210.107.206.172:3000/light';
    var data = {
      "light": _lightValue.toString(),
      "time": new DateTime.now().toString()
    };
    await http.post(url, body: data);
  }

  void onData(int luxValue) async {
    setState(()=>_lightValue = luxValue);
  }

  void startListening() {
    _light = new Light();
    _subscription = _light.lightSensorStream.listen(onData);
  }

  void stopListening() {
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('조도 화면')
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('조도 : ${_lightValue}', style: TextStyle(fontSize: 20),),
            ],
          ),
        )
    );
  }

  _backToMainPage(BuildContext context) => Navigator.pop(context);

}
