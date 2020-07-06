import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Position _position;
  String _geolocationStatus;
  List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPermission();
    _getCurrentPosition();
    _addLocationStream();
  }

   _getCurrentPosition() async {
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _position = position;
      });
  }

  _addLocationStream() {
    var geolocator = new Geolocator();
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions)
        .listen((Position position) {
      print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
      setState(() {
        _position = position;
      });
    });
    _streamSubscriptions.add(positionStream);
  }

  _checkPermission() async {
    GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
    setState(() {
      _geolocationStatus = geolocationStatus.toString();
    });
    await Permission.location.request();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('위치 화면')
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('위도 ${_position?.latitude}', style: TextStyle(fontSize: 30)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('경도 ${_position?.longitude}', style: TextStyle(fontSize: 30)),
              ],
            ),
            Text('${_geolocationStatus}')
          ],
        )
    );
  }

  _backToMainPage(BuildContext context) => Navigator.pop(context);
}