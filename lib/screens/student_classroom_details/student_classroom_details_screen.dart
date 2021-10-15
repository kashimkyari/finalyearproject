import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/student_classrooms.dart';

import '../../models/student_classroom.dart';
import '../../models/date.dart';

import '../../components/general_app_drawer.dart';
import '../../components/custom_dialog.dart';

import './attendance_table.dart';
import './student_painter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class StudentClassroomDetailsScreen extends StatefulWidget {
  static const String routName = '/studentClassroomDetails';

  StudentClassroomDetailsScreen({
    @required this.classroomStream,
    @required this.initialSnapshot,
  });

  final Stream<StudentClassroom> classroomStream;
  final StudentClassroom initialSnapshot;

  @override
  _StudentClassroomDetailsScreenState createState() =>
      _StudentClassroomDetailsScreenState();
}

class _StudentClassroomDetailsScreenState
    extends State<StudentClassroomDetailsScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String attendanceCode;
  String longCode;
  String latCode;
  TextEditingController locationController = new TextEditingController();
  var lat = 0.0;
  var long = 0.0;

  bool locPressed = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StudentClassroom>(
      stream: widget.classroomStream,
      initialData: widget.initialSnapshot,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          StudentClassroom classroom = snapshot.data;

          final DateTime date = DateTime.now();
          final Date now = Date.fromDateTime(date);

          int startTimeHour =
              int.tryParse(classroom.startTime.split(':')[0]) ?? 0;
          int startTimeMinute =
              int.tryParse(classroom.startTime.split(':')[1]) ?? 0;
          int endTimeHour = int.tryParse(classroom.endTime.split(':')[0]) ?? 0;
          int endTimeMinute =
              int.tryParse(classroom.endTime.split(':')[1]) ?? 0;

          bool online = classroom.weekDay == date.weekday &&
              (date.hour >= startTimeHour ||
                  (date.hour == startTimeHour &&
                      date.minute >= startTimeMinute)) &&
              (date.hour <= endTimeHour ||
                  (date.hour == endTimeHour && date.minute <= endTimeMinute));

          bool enableAttend = online && classroom.lastDateAttended.before(now);

          print(classroom.lastDateAttended);

          Size size = MediaQuery.of(context).size;
          double sh = size.height;
          // ignore: unused_local_variable
          double sw = size.width;

          return Scaffold(
            drawer: GeneralAppDrawer(
              userType: "student",
            ),
            appBar: AppBar(
              backgroundColor: Colors.red,
              elevation: 1.5,
              title: Text(
                '${classroom.name}',
                style: TextStyle(fontSize: 18),
              ),
              actions: <Widget>[
                Center(
                  child: Text(
                    online ? "Active" : "Inactive",
                  ),
                ),
                Container(
                  height: 15,
                  width: 15,
                  margin: EdgeInsets.only(right: 30, left: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: online ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            body: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 50,
                  child: AttendanceTable(
                    classroom: classroom,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 0.50 * sh,
                  child: CustomPaint(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: 50.0,
                            width: 300.0,
                            margin: EdgeInsets.only(top: 100.0),
                            child: Builder(
                              builder: (ctx) => RaisedButton(
                                onPressed: enableAttend
                                    ? () async {
                                        if (_formKey.currentState.validate()) {
                                          _formKey.currentState.save();

                                          try {
                                            await Provider.of<
                                                        StudentClassrooms>(
                                                    context,
                                                    listen: false)
                                                .attend(
                                                    classroomCode: classroom.id,
                                                    attendanceCode:
                                                        attendanceCode,
                                                    latCode: lat,
                                                    longCode: long
                                                    // latCode: lat
                                                    );

                                            classroom.lastDateAttended = now;
                                            setState(() {});

                                            ScaffoldMessenger.of(ctx)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Attended today 🍇",
                                                ),
                                              ),
                                            );
                                          } catch (error) {
                                            showErrorDialog(
                                                context, error.toString());
                                          }
                                        }
                                      }
                                    : null,
                                child: Text(
                                  'Mark Present',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Colors.green,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(
                                          95.0, 0.0, 95.0, 0.0),
                                      child: TextFormField(
                                        enabled: enableAttend,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(163, 160, 185, 1),
                                        ),
                                        decoration: inputDecoration.copyWith(
                                            hintText: "Enter Attendance code"),
                                        keyboardType: TextInputType.number,
                                        validator: (code) {
                                          if (code == "")
                                            return "code is required";
                                          return code.length <= 3
                                              ? "code >= 4 characters"
                                              : null;
                                        },
                                        onSaved: (code) {
                                          attendanceCode = code;
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(
                                          50.0, 10.0, 50.0, 0.0),
                                      child: Column(children: <Widget>[
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                locPressed = true;
                                              });
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      new FocusNode());
                                              getUserLocation();
                                            },
                                            child: TextFormField(
                                                textAlign: TextAlign.center,
                                                enabled: false,
                                                controller: locationController,
                                                maxLines: 3,
                                                decoration:
                                                    inputDecoration.copyWith(
                                                  hintText: locPressed
                                                      ? "Locating.."
                                                      : "Click icon to get Location",
                                                  border: InputBorder.none,
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      Icons.my_location,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                )))
                                      ]),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
    List<Placemark> placemarks = await GeocodingPlatform.instance
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '  ${placemark.thoroughfare}, ${placemark.administrativeArea}, ${placemark.country}';
    locationController.text = completeAddress;
  }
}

final inputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.only(
    top: 2.5,
    bottom: 2.5,
    left: 2.0,
    right: 2.0,
  ),
  filled: true,
  fillColor: Color.fromRGBO(190, 190, 190, 10),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide.none,
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide.none,
  ),
  hintStyle: TextStyle(
    fontSize: 16,
    color: Colors.black45,
  ),
);
