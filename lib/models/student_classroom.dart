import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import './classroom.dart';
import './date.dart';

class StudentClassroom extends Classroom {
  String _instructorName;
  String _instructorEmail;
  String _lat;
  String _long;
  Date _lastDateAttended;
  List<String> _sessions;

  String get instructorName => this._instructorName;

  set instructorName(String instructorName) {
    this._instructorName = instructorName;
  }

  String get instructorEmail => this._instructorEmail;

  set instructorEmail(String instructorEmail) {
    this._instructorEmail = instructorEmail;
  }

  String get lat => this._lat;

  set lat(String lat) {
    this._lat = lat;
  }

  String get long => this._long;

  set long(String long) {
    this._long = long;
  }

  Date get lastDateAttended => this._lastDateAttended;

  set lastDateAttended(Date lastDateAttended) {
    this._lastDateAttended = lastDateAttended;
  }

  List<String> get sessions => this._sessions;

  set sessions(List<String> sessions) {
    this._sessions = sessions;
  }

  StudentClassroom({
    @required String id,
    @required String name,
    @required Date createdAt,
    @required int weekDay,
    @required String startTime,
    @required String endTime,
    @required String instructorName,
    @required String instructorEmail,
    @required String lat,
    @required String long,
    @required Date lastDateAttended,
    List<String> sessions,
  }) : super(
            id: id,
            name: name,
            createdAt: createdAt,
            weekDay: weekDay,
            startTime: startTime,
            endTime: endTime) {
    this._instructorName = instructorName;
    this._instructorEmail = instructorEmail;
    this._lat = lat;
    this._long = long;
    this._lastDateAttended = lastDateAttended;
    this._sessions = sessions;
  }

  static StudentClassroom fromMap(DocumentSnapshot classroomDocument) {
    Map<String, dynamic> classroom = classroomDocument.data;

    print(classroom);

    return StudentClassroom(
      id: classroomDocument.documentID ?? "",
      name: classroom['name'] ?? "",
      createdAt: classroom['createdAt'] == null
          ? Date.fromDateTime(DateTime.now())
          : Date.fromMap(classroom['createdAt']),
      weekDay: classroom['weekDay'] ?? 0,
      startTime: classroom['startTime'] ?? "00:00",
      endTime: classroom['endTime'] ?? "00:00",
      instructorName: classroom['instructorName'] ?? "",
      instructorEmail: classroom['instructorEmail'] ?? "",
      lat: classroom['lat'] ?? "",
      long: classroom['long'] ?? "",
      lastDateAttended:
          classroom['lastDateAttended'] ?? Date(day: 4, month: 10, year: 2021),
      sessions: (classroom['sessions'] == null
              ? []
              : classroom['sessions'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
    );
  }
}
