import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/instructor_classrooms.dart';

import '../../models/instructor_classroom.dart';
import '../../models/instructor_student.dart';

import '../../components/custom_dialog.dart';

import './instructor_painter.dart';

class InstructorBody extends StatefulWidget {
  const InstructorBody({
    @required this.classroom,
    @required this.initialStudentsSnapshot,
  });

  final InstructorClassroom classroom;
  final List<InstructorStudent> initialStudentsSnapshot;

  @override
  _InstructorBodyState createState() => _InstructorBodyState();
}

class _InstructorBodyState extends State<InstructorBody> {
  bool enable = true;

  GlobalKey<FormState> _formKey;
  TextEditingController _numOfStudentsController;
  TextEditingController _attendanceCodeController;

  String attendanceCode;
  int numOfStudents;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _numOfStudentsController = TextEditingController();
    _attendanceCodeController = TextEditingController();
    _numOfStudentsController.text = '0';
  }

  @override
  void dispose() {
    super.dispose();

    _numOfStudentsController.dispose();
    _attendanceCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sh = size.height;
    double sw = size.width;

    InstructorClassrooms _staticInstructor =
        Provider.of<InstructorClassrooms>(context, listen: false);

    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              enable
                  ? Container(
                      height: sh * 0.68,
                      child: StreamBuilder<List<InstructorStudent>>(
                        stream: widget.classroom.students,
                        initialData: widget.initialStudentsSnapshot,
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            List<InstructorStudent> students = snapshot.data;

                            return ListView.builder(
                              itemCount: students.length,
                              itemBuilder: (_, index) {
                                return Card(
                                  color: students[index]
                                          .lastDateAttended
                                          .sameDateTime(DateTime.now())
                                      ? Colors.green
                                      : Colors.white,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: Text(
                                        students[index]
                                            .sessions
                                            .length
                                            .toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor:
                                          Color.fromRGBO(206, 20, 94, 1.0),
                                    ),
                                    title: Text(
                                      students[index].name,
                                      style: TextStyle(
                                          color: students[index]
                                                  .lastDateAttended
                                                  .sameDateTime(DateTime.now())
                                              ? Colors.white
                                              : Colors.grey,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    trailing: Text(
                                      students[index].collegeId,
                                      style: TextStyle(
                                        color: students[index]
                                                .lastDateAttended
                                                .sameDateTime(DateTime.now())
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    )
                  : Container(height: sh * 0.7),
            ],
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            height: 0.35 * sh,
            child: CustomPaint(
              painter: InstructorPainter(),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0.20 * sh - 120,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey),
                        child: IconButton(
                          iconSize: 33,
                          icon: Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                          onPressed: enable
                              ? () {
                                  return _numOfStudentsController.text == "" ||
                                          int.tryParse(_numOfStudentsController
                                                  .text) ==
                                              null ||
                                          int.tryParse(_numOfStudentsController
                                                  .text) <=
                                              1
                                      ? _numOfStudentsController.text = "1"
                                      : _numOfStudentsController.text =
                                          (int.tryParse(_numOfStudentsController
                                                      .text) -
                                                  1)
                                              .toString();
                                }
                              : null,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 40,
                        width: 100,
                        child: TextFormField(
                          enabled: enable,
                          controller: _numOfStudentsController,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(163, 160, 185, 1),
                          ),
                          decoration: inputDecoration.copyWith(hintText: "num"),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (quantity) {
                            if (quantity == "") return "Number";
                            return int.tryParse(quantity) == null ||
                                    int.tryParse(quantity) <= 0
                                ? "Not a Number"
                                : null;
                          },
                          onSaved: (quantity) {
                            numOfStudents = int.parse(quantity);
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(70, 231, 35, 1.0),
                        ),
                        child: IconButton(
                          iconSize: 33,
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          splashColor: Colors.grey,
                          onPressed: enable
                              ? () {
                                  return _numOfStudentsController.text == "" ||
                                          int.tryParse(_numOfStudentsController
                                                  .text) ==
                                              null
                                      ? _numOfStudentsController.text = "1"
                                      : _numOfStudentsController.text =
                                          (int.tryParse(_numOfStudentsController
                                                      .text) +
                                                  1)
                                              .toString();
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 40,
                    width: 200,
                    child: TextFormField(
                      enabled: enable,
                      controller: _attendanceCodeController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(163, 160, 185, 1),
                      ),
                      decoration:
                          inputDecoration.copyWith(hintText: "Attendance code"),
                      keyboardType: TextInputType.number,
                      validator: (code) {
                        if (code == "") return "Please, enter a code";
                        return code.length <= 3 ? "code >= 4 characters" : null;
                      },
                      onSaved: (code) {
                        attendanceCode = code;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 30, left: 0.15 * sw, right: 0.15 * sw),
                    height: 45,
                    width: double.maxFinite,
                    child: Selector<InstructorClassrooms, bool>(
                      selector: (_, instructor) {
                        return instructor.updateAttendanceConstraintsLoading;
                      },
                      builder: (_, loading, __) => loading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : FlatButton(
                              color: Colors.green,
                              child: Text(
                                "UPDATE",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();

                                  _staticInstructor
                                          .updateAttendanceConstraintsLoading =
                                      true;

                                  try {
                                    await _staticInstructor
                                        .updateAttendanceConstraints(
                                      classroomId: widget.classroom.id,
                                      attendanceCode: this.attendanceCode,
                                      numOfStudents: this.numOfStudents,
                                    );
                                  } catch (error) {
                                    showErrorDialog(context, error);
                                  }

                                  _staticInstructor
                                          .updateAttendanceConstraintsLoading =
                                      false;
                                }
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(fontSize: 16));
