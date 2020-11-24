import 'package:flutter/material.dart';
import 'package:health_plus/module/appointment.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../app.dart';
import '../login_screen.dart';

// ignore: non_constant_identifier_names
String tot_appointment;

class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  var patientID = patient_id;
  var doctorID = admin_id;
  List<Appoint> data = [];
  String state;
  bool confirmed;

  @override
  void initState() {
    super.initState();
  }

  getAppointments_() async {
    var result = await http_get({
      "action": "get_appointments",
      "patient_id": patientID,
      "doctor_id": doctorID
    });
    if (result.ok) {
      setState(() {
        data.clear();
        var jsonItems = result.data as List<dynamic>;
        jsonItems.forEach((appointment) {
          this.data.add(Appoint(
                appointment['id'] as String,
                appointment['appointment_date'] as String,
                appointment['appointment_time'] as String,
                appointment['description'] as String,
                appointment['status'] as String,
              ));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
        getAppointments_();
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _landscapeOrientation();
          } else {
            return _portraitOrientation();
          }
        },
      ),
    );
  }

  Widget _portraitOrientation() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          height: 300.0,
          decoration: BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30))),
          child: Card(
            elevation: 30.0,
            color: Color.fromARGB(255, 212, 234, 244),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SfCalendar(
                view: CalendarView.month,
                showNavigationArrow: true,
              ),
            ),
          ),
        ),
        Expanded(
          child: new ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (context, i) {
                state = data[i].status;
                if (state == "2") {
                  confirmed = true;
                } else {
                  confirmed = false;
                }
                return Container(
                  height: 90.0,
                  child: Card(
                    elevation: 1.0,
                    color: Color.fromARGB(255, 212, 234, 244),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 10.0),
                        CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: IconButton(
                              icon: Icon(
                                Icons.assignment_turned_in,
                                size: 30.0,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      bool checked;
                                      var status = data[i].status;
                                      if (status == '2') {
                                        checked = true;
                                      } else {
                                        checked = false;
                                      }
                                      return AlertDialog(
                                        backgroundColor: Colors.black45,
                                        content: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 200.0,
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Appointment Details',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Container(
                                                  color: Colors.white,
                                                  height: 1.0,
                                                ),
                                                Spacer(),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    'Description :',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'OpenSans',
                                                        fontSize: 10.0,
                                                        fontWeight:
                                                            FontWeight.w200),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    data[i].description,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'OpenSans',
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w200),
                                                  ),
                                                ),
                                                Spacer(),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    'Date and Time: ',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'OpenSans',
                                                        fontSize: 10.0,
                                                        fontWeight:
                                                            FontWeight.w200),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    '${data[i].appointment_date} at ${data[i].appointment_time}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'OpenSans',
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w200),
                                                  ),
                                                ),
                                                Spacer(),
                                                Row(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        'Status: ',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'OpenSans',
                                                            fontSize: 10.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w200),
                                                      ),
                                                    ),
                                                    checked
                                                        ? Container(
                                                            height: 20.0,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2.0),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30.0),
                                                                color: Colors
                                                                    .green),
                                                            child: Text(
                                                              'Checked',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'Lato',
                                                                  fontSize:
                                                                      10.0),
                                                            ),
                                                          )
                                                        : Container(
                                                            height: 20.0,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2.0),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30.0),
                                                                color: Colors
                                                                    .deepOrangeAccent),
                                                            child: Text(
                                                              'Unchecked',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'Lato',
                                                                  fontSize:
                                                                      10.0),
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                                Spacer(),
                                                FlatButton(
                                                    color: Colors.blueGrey,
                                                    onPressed: () =>
                                                        Navigator.of(context).pop(),
                                                    child: Text('Close', style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 15.0,
                                                        fontFamily: 'OpenSans'
                                                    ),)),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                            )),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Text(
                                    'Description',
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Spacer(),
                                  confirmed
                                      ? Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            height: 20.0,
                                            padding: EdgeInsets.all(2.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                color: Colors.green),
                                            child: Text(
                                              'Checked',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Lato',
                                                  fontSize: 10.0),
                                            ),
                                          ),
                                        )
                                      : Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            height: 20.0,
                                            padding: EdgeInsets.all(2.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                color: Colors.deepOrangeAccent),
                                            child: Text(
                                              'Unchecked',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Lato',
                                                  fontSize: 10.0),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                data[i].description,
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Divider(
                                thickness: 3.0,
                                color: Colors.blueGrey,
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Icon(Icons.calendar_today,
                                        size: 15.0, color: Colors.blue),
                                    SizedBox(width: 2.0),
                                    Text(data[i].appointment_date,
                                        style: TextStyle(
                                            fontSize: 10.0,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.w700)),
                                    Spacer(),
                                    Icon(Icons.timer,
                                        size: 15.0, color: Colors.blue),
                                    SizedBox(width: 2.0),
                                    Text(data[i].appointment_time,
                                        style: TextStyle(
                                            fontSize: 10.0,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.w700)),
                                    Spacer()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget _landscapeOrientation() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          height: 300.0,
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30))),
          child: Card(
            elevation: 30.0,
            color: Color.fromARGB(255, 212, 234, 244),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SfCalendar(
                view: CalendarView.month,
                showNavigationArrow: true,
              ),
            ),
          ),
        ),
        Expanded(
          child: new ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (context, i) {
                state = data[i].status;
                if (state == "2") {
                  confirmed = true;
                } else {
                  confirmed = false;
                }
                return Container(
                  height: 90.0,
                  child: Card(
                    elevation: 1.0,
                    color: Color.fromARGB(255, 212, 234, 244),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 10.0),
                      CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: IconButton(
                            icon: Icon(
                              Icons.assignment_turned_in,
                              size: 30.0,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    bool checked;
                                    var status = data[i].status;
                                    if (status == '2') {
                                      checked = true;
                                    } else {
                                      checked = false;
                                    }
                                    return AlertDialog(
                                      backgroundColor: Colors.black45,
                                      content: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 200.0,
                                          child: Column(
                                            children: [
                                              Text(
                                                'Appointment Details',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                    FontWeight.w500),
                                              ),
                                              Container(
                                                color: Colors.white,
                                                height: 1.0,
                                              ),
                                              Spacer(),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  'Description :',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                      FontWeight.w200),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  data[i].description,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                      FontWeight.w200),
                                                ),
                                              ),
                                              Spacer(),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  'Date and Time: ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                      FontWeight.w200),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  '${data[i].appointment_date} at ${data[i].appointment_time}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                      FontWeight.w200),
                                                ),
                                              ),
                                              Spacer(),
                                              Row(
                                                children: [
                                                  Align(
                                                    alignment:
                                                    Alignment.topLeft,
                                                    child: Text(
                                                      'Status: ',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                          'OpenSans',
                                                          fontSize: 10.0,
                                                          fontWeight:
                                                          FontWeight
                                                              .w200),
                                                    ),
                                                  ),
                                                  checked
                                                      ? Container(
                                                    height: 20.0,
                                                    padding:
                                                    EdgeInsets.all(
                                                        2.0),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            30.0),
                                                        color: Colors
                                                            .green),
                                                    child: Text(
                                                      'Checked',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontFamily:
                                                          'Lato',
                                                          fontSize:
                                                          10.0),
                                                    ),
                                                  )
                                                      : Container(
                                                    height: 20.0,
                                                    padding:
                                                    EdgeInsets.all(
                                                        2.0),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            30.0),
                                                        color: Colors
                                                            .deepOrangeAccent),
                                                    child: Text(
                                                      'Unchecked',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontFamily:
                                                          'Lato',
                                                          fontSize:
                                                          10.0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              FlatButton(
                                                  color: Colors.blueGrey,
                                                  onPressed: () =>
                                                      Navigator.of(context).pop(),
                                                  child: Text('Close', style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 15.0,
                                                      fontFamily: 'OpenSans'
                                                  ),)),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                          )),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Text(
                                    'Description',
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Spacer(),
                                  confirmed
                                      ? Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            height: 20.0,
                                            padding: EdgeInsets.all(2.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                color: Colors.green),
                                            child: Text(
                                              'Checked',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Lato',
                                                  fontSize: 10.0),
                                            ),
                                          ),
                                        )
                                      : Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            height: 20.0,
                                            padding: EdgeInsets.all(2.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                color: Colors.deepOrangeAccent),
                                            child: Text(
                                              'Unchecked',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Lato',
                                                  fontSize: 10.0),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                data[i].description,
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Divider(
                                thickness: 3.0,
                                color: Colors.blueGrey,
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Icon(Icons.calendar_today,
                                        size: 15.0, color: Colors.blue),
                                    SizedBox(width: 2.0),
                                    Text(data[i].appointment_date,
                                        style: TextStyle(
                                            fontSize: 10.0,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.w700)),
                                    Spacer(),
                                    Icon(Icons.timer,
                                        size: 15.0, color: Colors.blue),
                                    SizedBox(width: 2.0),
                                    Text(data[i].appointment_time,
                                        style: TextStyle(
                                            fontSize: 10.0,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.w700)),
                                    Spacer()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
