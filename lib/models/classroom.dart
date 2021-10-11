import 'package:flutter/foundation.dart';

import './date.dart';

class Classroom {
  String _id;
  String _name;
  Date _createdAt;
  int _weekDay;
  String _startTime;
  String _endTime;
  String _long;
  String _lat;

  String get id => this._id;
  String get name => this._name;
  Date get createdAt => this._createdAt;
  int get weekDay => this._weekDay;
  String get startTime => this._startTime;
  String get endTime => this._endTime;
  String get lat => this._lat;
  String get long => this._long;

  set id(String id) {
    this._id = id;
  }

  set name(String name) {
    this._name = name;
  }

  set createdAt(Date createdAt) {
    this._createdAt = createdAt;
  }

  set weekDay(int weekDay) {
    this._weekDay = weekDay;
  }

  set day(int day) {
    this._weekDay = day;
  }

  set startTime(String startTime) {
    this._startTime = startTime;
  }

  set endTime(String endTime) {
    this._endTime = endTime;
  }

  set lat(String lat) {
    this._lat = lat;
  }

  set long(String long) {
    this._long = long;
  }

  Classroom(
      {@required String id,
      @required String name,
      @required Date createdAt,
      @required int weekDay,
      @required String startTime,
      @required String endTime,
      @required String lat,
      @required String long}) {
    this._id = id;
    this._name = name;
    this._createdAt = createdAt;
    this._weekDay = weekDay;
    this._startTime = startTime;
    this._endTime = endTime;
    this._lat = lat;
    this._long = long;
  }
}
