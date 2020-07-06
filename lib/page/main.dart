import 'package:flutter/material.dart';

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
              ],

            )
        )

    );
  }
}