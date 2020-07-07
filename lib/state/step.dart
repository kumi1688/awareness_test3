import 'package:flutter/material.dart';

class stepState extends ChangeNotifier {
  String _latitude;
  String _longitutde;
  int _step;
  String _time;
  String _network;
  String _blutooth;
  String _acc;
  String _light;
  String _acitivity;

  int get step => _step;
  void set step(int step) => _step = step;

  String get latitude => _latitude;
  void set latitude(String latitude) => _latitude = latitude;

  String get longitude => _longitutde;
  void set longitude(String longitude) => _longitutde = longitude;

  String get time => _time;
  void set time(String time) => _time = time;
}