import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:health_plus/module/chat.dart';
import 'package:health_plus/module/reminder.dart';

import '../../app.dart';
import '../login_screen.dart';

String description,
    from_doctor,
    from_patient,
    status,
    msg_time,
    msg_date,
    reminder_date,
    reminder_status;

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  var patientID = patient_id;
  var doctorID = admin_id;
  List<Chat> data = [];
  List<Reminder> data_ = [];
  TabController _tabController;
  var m_id;
  var id_appointment;
  var id_reminder;

  @override
  void initState() {
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
    super.initState();
  }

  getChats_() async {
    var result = await http_get({
      "action": "get_notifications",
      "patient_id": patientID,
      "doctor_id": doctorID
    });
    if (result.ok) {
      setState(() {
        data.clear();
        var jsonItems = result.data as List<dynamic>;
        jsonItems.forEach((post) {
          this.data.add(Chat(
                post['id'] as String,
                post['patient_id'] as String,
                post['doctor_id'] as String,
                description = post['description'] as String,
                from_patient = post['from_patient'] as String,
                from_doctor = post['from_doctor'] as String,
                status = post['status'] as String,
                msg_time = post['msg_time'] as String,
                msg_date = post['msg_date'] as String,
              ));
        });
      });
    }
  }

  getReminder_() async {
    var result = await http_get({
      "action": "get_reminders",
      "patient_id": patientID,
      "doctor_id": doctorID
    });
    if (result.ok) {
      setState(() {
        data_.clear();
        var jsonItems = result.data as List<dynamic>;
        jsonItems.forEach((reminder) {
          this.data_.add(Reminder(
                reminder['id'] as String,
                reminder['appointment_id'] as String,
                reminder['remind_date'] as String,
                reminder['status'] as String,
              ));
        });
      });
    }
  }

  updateStatus() async {
    http_get({
      "action": "edit_status",
      "message_id": m_id,
    });
  }

  updateStatusAppointment() async {
    http_get({
      "action": "change_appointment_status",
      "appointment_id": id_appointment,
    });
  }

  updateStatusReminder() async {
    http_get({
      "action": "reminder_status",
      "reminder_id": id_reminder,
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getChats_();
    });
    setState(() {
      getReminder_();
    });
    return Scaffold(
        body: Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: [
            SizedBox(height: 25.0),
            SizedBox(
              height: 50,
              child: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 5.0,
                bottom: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                      child: Text(
                        'Messages',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            fontFamily: 'OpenSans'),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Reminders',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            fontFamily: 'OpenSans'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  child: new ListView.builder(
                      itemCount: data == null ? 0 : data.length,
                      itemBuilder: (context, i) {
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
                                    backgroundColor: Colors.white38,
                                    child: FloatingActionButton(
                                      backgroundColor: Colors.black,
                                      elevation: 0.0,
                                      child: Icon(
                                        Icons.account_circle,
                                        size: 40.0,
                                        color: Colors.yellow,
                                      ),
                                      tooltip: 'Open',
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              m_id = data[i].id;
                                              return AlertDialog(
                                                backgroundColor: Colors.black45,
                                                content: Container(
                                                  height: 300.0,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'Message',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'OpenSans',
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Container(
                                                        color: Colors.white,
                                                        height: 1.0,
                                                      ),
                                                      Spacer(),
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          'Content :',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'OpenSans',
                                                              fontSize: 10.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          data[i].description,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'OpenSans',
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          'Date and Time: ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'OpenSans',
                                                              fontSize: 10.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          '${data[i].msg_date} at ${data[i].msg_time}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'OpenSans',
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      FlatButton(
                                                          color:
                                                              Colors.blueGrey,
                                                          onPressed: () {
                                                            updateStatus();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'Close',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 15.0,
                                                                fontFamily:
                                                                    'OpenSans'),
                                                          )),
                                                      Spacer()
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                    )),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5.0),
                                      Row(
                                        children: [
                                          Text(
                                            'Hospital',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                          Spacer(),
                                          Text(data[i].msg_time,
                                              style: TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                          SizedBox(width: 5.0)
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
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),

                // second tab bar view widget

                Container(

                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 600) {
                          return _landscapeOrientation();
                        } else {
                          return _portraitOrientation();
                        }
                      },
                    ) ,
                )
              ],
            ))
          ],
        ),
      ),
    ));
  }

  _portraitOrientation(){
    return Column(
      children: [
        Container(
            padding: EdgeInsets.symmetric(
                vertical: 5.0, horizontal: 20.0),
            height: 200.0,
            decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30))),
            child: Center(
              child: AnalogClock(
                decoration: BoxDecoration(
                    border:
                    Border.all(width: 3.0, color: Colors.black),
                    color: Colors.black,
                    shape: BoxShape.circle),
                width: 200.0,
                isLive: true,
                hourHandColor: Colors.white,
                minuteHandColor: Colors.white,
                showSecondHand: true,
                numberColor: Colors.white,
                showNumbers: true,
                textScaleFactor: 1.5,
                showTicks: true,
                showDigitalClock: true,
                digitalClockColor: Colors.white,
                datetime: DateTime(2020, 8, 4, 9, 11, 0),
              ),
            )),
        Container(
          child: Expanded(
              child: ListView.builder(
                  itemCount: data_ == null ? 0 : data_.length,
                  itemBuilder: (context, i) {
                    return Container(
                      height: 90.0,
                      child: Card(
                        elevation: 1.0,
                        color: Color.fromARGB(255, 212, 234, 244),
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 10.0),
                            CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Colors.white38,
                                child: FloatingActionButton(
                                  backgroundColor: Colors.black,
                                  elevation: 0.0,
                                  child: Icon(
                                    Icons.alarm_on_outlined,
                                    size: 40.0,
                                    color: Colors.yellow,
                                  ),
                                  tooltip: 'Open',
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder:
                                            (BuildContext context) {
                                          id_appointment =
                                              data_[i].appointment_id;
                                          id_reminder = data_[i].id;
                                          return AlertDialog(
                                            backgroundColor:
                                            Colors.black45,
                                            content: Container(
                                              height: 150.0,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Reminder',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white,
                                                        fontFamily:
                                                        'OpenSans',
                                                        fontSize:
                                                        20.0,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500),
                                                  ),
                                                  Container(
                                                    color:
                                                    Colors.white,
                                                    height: 1.0,
                                                  ),
                                                  Spacer(),
                                                  Align(
                                                    alignment:
                                                    Alignment
                                                        .topLeft,
                                                    child: Text(
                                                      'Sent on :',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontFamily:
                                                          'OpenSans',
                                                          fontSize:
                                                          10.0,
                                                          fontWeight:
                                                          FontWeight
                                                              .w200),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                    Alignment
                                                        .topLeft,
                                                    child: Text(
                                                      data_[i]
                                                          .remind_date,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontFamily:
                                                          'OpenSans',
                                                          fontSize:
                                                          15.0,
                                                          fontWeight:
                                                          FontWeight
                                                              .w200),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  FlatButton(
                                                      color: Colors
                                                          .blueGrey,
                                                      onPressed: () {
                                                        updateStatusAppointment();
                                                        updateStatusReminder();
                                                        Navigator.of(
                                                            context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        'Close',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                            fontSize:
                                                            15.0,
                                                            fontFamily:
                                                            'OpenSans'),
                                                      )),
                                                  Spacer()
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                )),
                            SizedBox(width: 10.0),
                            Center(
                              child: Text(
                                data_[i].remind_date, style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 18.0,

                              ),
                              ),
                            ),
                            SizedBox(width: 20.0,),
                            Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  color: Colors.red.shade300,
                                  borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: Text('Need Confirmation ',style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 12.0, fontWeight: FontWeight.w500, color: Colors.white

                              )),
                            )
                          ],
                        ),
                      ),
                    );
                  })),
        )
      ],
    );
  }

  _landscapeOrientation(){
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 3,
            padding: EdgeInsets.symmetric(
                vertical: 5.0, horizontal: 20.0),
            height: 200.0,
            decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30))),
            child: Center(
              child: AnalogClock(
                decoration: BoxDecoration(
                    border:
                    Border.all(width: 3.0, color: Colors.black),
                    color: Colors.black,
                    shape: BoxShape.circle),
                width: 200.0,
                isLive: true,
                hourHandColor: Colors.white,
                minuteHandColor: Colors.white,
                showSecondHand: true,
                numberColor: Colors.white,
                showNumbers: true,
                textScaleFactor: 1.5,
                showTicks: true,
                showDigitalClock: true,
                digitalClockColor: Colors.white,
                datetime: DateTime(2020, 8, 4, 9, 11, 0),
              ),
            )),
        Container(
          child: Expanded(
              child: ListView.builder(
                  itemCount: data_ == null ? 0 : data_.length,
                  itemBuilder: (context, i) {
                    return Container(
                      height: 90.0,
                      child: Card(
                        elevation: 1.0,
                        color: Color.fromARGB(255, 212, 234, 244),
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 10.0),
                            CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Colors.white38,
                                child: FloatingActionButton(
                                  backgroundColor: Colors.black,
                                  elevation: 0.0,
                                  child: Icon(
                                    Icons.alarm_on_outlined,
                                    size: 40.0,
                                    color: Colors.yellow,
                                  ),
                                  tooltip: 'Open',
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder:
                                            (BuildContext context) {
                                          id_appointment =
                                              data_[i].appointment_id;
                                          id_reminder = data_[i].id;
                                          return AlertDialog(
                                            backgroundColor:
                                            Colors.black45,
                                            content: Container(
                                              height: 150.0,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Reminder',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white,
                                                        fontFamily:
                                                        'OpenSans',
                                                        fontSize:
                                                        20.0,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500),
                                                  ),
                                                  Container(
                                                    color:
                                                    Colors.white,
                                                    height: 1.0,
                                                  ),
                                                  Spacer(),
                                                  Align(
                                                    alignment:
                                                    Alignment
                                                        .topLeft,
                                                    child: Text(
                                                      'Sent on :',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontFamily:
                                                          'OpenSans',
                                                          fontSize:
                                                          10.0,
                                                          fontWeight:
                                                          FontWeight
                                                              .w200),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                    Alignment
                                                        .topLeft,
                                                    child: Text(
                                                      data_[i]
                                                          .remind_date,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontFamily:
                                                          'OpenSans',
                                                          fontSize:
                                                          15.0,
                                                          fontWeight:
                                                          FontWeight
                                                              .w200),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  FlatButton(
                                                      color: Colors
                                                          .blueGrey,
                                                      onPressed: () {
                                                        updateStatusAppointment();
                                                        updateStatusReminder();
                                                        Navigator.of(
                                                            context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        'Close',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                            fontSize:
                                                            15.0,
                                                            fontFamily:
                                                            'OpenSans'),
                                                      )),
                                                  Spacer()
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                )),
                            SizedBox(width: 10.0),
                            Center(
                              child: Text(
                                data_[i].remind_date, style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 18.0,

                              ),
                              ),
                            ),
                            SizedBox(width: 20.0,),
                            Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: Colors.red.shade300,
                                borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: Text('Need Confirmation ',style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 12.0, fontWeight: FontWeight.w500, color: Colors.white

                              )),
                            )
                          ],
                        ),
                      ),
                    );
                  })),
        )
      ],
    );
  }
}
