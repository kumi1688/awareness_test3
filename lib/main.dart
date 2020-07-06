import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Location.dart';

import 'page/location.dart';
import 'page/main.dart';
import 'page/accelator.dart';
import 'page/step.dart';
import 'page/light.dart';
import 'page/activity_recognition.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context)=>Location(),
    child: LocationDemoV1()
  ));

class LocationDemoV1 extends StatefulWidget {
  @override
  _LocationDemoV1State createState() => _LocationDemoV1State();
}

class _LocationDemoV1State extends State<LocationDemoV1> {

  static const String MAIN_PAGE = '/';
  static const String LOCATION_PAGE = '/location';
  static const String ACCELATOR_PAGE = '/accelator';
  static const String STEP_PAGE = '/step';
  static const String LIGHT_PAGE = '/light';
  static const String ACTIVITY_RECOGNITION_PAGE = '/activity_recognition';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: MAIN_PAGE,
      routes: {
        MAIN_PAGE : (context) => MainPage(),
        LOCATION_PAGE : (context) => LocationPage(),
        ACCELATOR_PAGE: (context) => AccelatorPage(),
        STEP_PAGE: (context) => StepPage(),
        LIGHT_PAGE: (context) => LightPage(),
        ACTIVITY_RECOGNITION_PAGE: (context) => ActivityRecognitionPage()
      }
    );
  }
}


