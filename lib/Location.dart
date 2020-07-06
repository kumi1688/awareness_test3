import 'package:flutter/material.dart';

class Location extends ChangeNotifier {
  String _latitude;
  String _longitutde;

  void setLatitude(String latitude){
    _latitude = latitude;
  }

  void setLongitude(String longitude){
    _longitutde = longitude;
  }
}