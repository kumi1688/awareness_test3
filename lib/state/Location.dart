import 'package:flutter/material.dart';

class Location extends ChangeNotifier {
  String _latitude;
  String _longitutde;
  int _step;
  String _network;
  String _blutooth;
  String _acc;
  String _light;
  String _acitivity;

  int get step => _step;

  void set step(int step) => _step = step;


  void set latitude(String latitude){
    _latitude = latitude;
  }

  void set longitude(String longitude){
    _longitutde = longitude;
  }
}