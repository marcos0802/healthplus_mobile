import 'dart:async';
import 'dart:convert';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:health_plus/module/chat.dart';
import 'package:http/http.dart' as http;

import '../../app.dart';
import '../login_screen.dart';

String description, from_doctor, from_patient, status, msg_time, msg_date;

class Chats extends StatefulWidget {
  @override
  ChatsState createState() {
    return new ChatsState();
  }
}

class ChatsState extends State<Chats> {
  var patientID = patient_id;
  var doctorID = admin_id;
  var sender, status_;
  bool isMe, isRead;
  String msg_id, msg;
  List<Chat> data = [];

  TextEditingController message;
  TextInputAction _textInputAction = TextInputAction.newline;
  String _message = '';

  @override
  void initState() {
    super.initState();
    bool enterIsSend = false;
    setState(() {
      if (enterIsSend) {
        _textInputAction = TextInputAction.send;
      } else {
        _textInputAction = TextInputAction.newline;
      }
    });

    message = new TextEditingController()
      ..addListener(() {
        setState(() {
          _message = message.text;
        });
      });
  }


  // ignore: non_constant_identifier_names
  getChats_() async {
    var result = await http_get({
      "action": "get_chats",
      "patient_id": patientID,
      "doctor_id": doctorID
    });
    if (result.ok) {
      setState(() {
        data.clear();
        var jsonItems = result.data as List<dynamic>;
        jsonItems.forEach((post) {
          this.data.add(Chat(
                msg_id = post['id'] as String,
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

  String response = "NULL";

  void sendNewMessage() async {
    var result = await http_get({
      "action": "new_message",
      "id": patientID,
      "admin_id": doctorID,
      "description": message.text,
    });
    setState(() {
      this.response = result.ok ? (result.data as String) : "Error";
    });
  }

  deleteMessage() async {
    http_get({
      "action": "delete_message",
      "message_id": msg,
    });
  }

  _buildMessageComposer() {

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
        height: 70.0,
        color: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(const Radius.circular(30.0)),
                      color: Colors.white),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        padding: const EdgeInsets.all(0.0),
                        color: Theme.of(context).primaryColor,
                        icon: Icon(
                          Icons.insert_emoticon,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                      Flexible(
                        child: TextField(
                          controller: message,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: _textInputAction,
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w700,
                              fontSize: 17.0),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(0.0),
                            hintText: 'Type a message',
                            hintStyle: TextStyle(
                                color: Colors.black45,
                                fontSize: 16.0,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600),
                            counterText: '',
                          ),
                          onSubmitted: (String text) {
                            if (_textInputAction == TextInputAction.send) {
                              sendNewMessage();
                              setState(() {
                                message.text = '';
                              });
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                            }
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          maxLength: 256,
                        ),
                      ),
                      IconButton(
                        color: Theme.of(context).primaryColor,
                        icon: Icon(Icons.attach_file),
                        onPressed: () {},
                      ),
                      _message.isEmpty || _message == null
                          ? IconButton(
                              color: Theme.of(context).primaryColor,
                              icon: Icon(Icons.camera_alt),
                              onPressed: () {},
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: FloatingActionButton(
                  elevation: 2.0,
                  child: _message.isEmpty || _message == null
                      ? Icon(Icons.settings_voice)
                      : Icon(Icons.send_outlined),
                  onPressed: () {
                    sendNewMessage();
                    setState(() {
                      message.text = '';
                    });
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  },
                ),
              )
            ],
          ),
        ));
  }


  @override
  Widget build(BuildContext context) {
    getChats_();
    String msg_src;

    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 70.0, left: 10.0),
      alignment: Alignment.topLeft,
    );
    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(245, 255, 255, 200),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 70.0, right: 10.0),
      alignment: Alignment.topRight,
    );

    return Scaffold(body: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Expanded(child: Container(
            padding: EdgeInsets.only(bottom: 10.0),
            color: Colors.black12,
            child: new ListView.builder(
              reverse: true,
              shrinkWrap: true,
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (context, i) {
                msg_src = data[i].from_patient;
                msg_date = data[i].msg_date;
                msg_time = data[i].msg_time;
                status = data[i].status;
                // ignore: unrelated_type_equality_checks
                if (msg_src == '1') {
                  isMe = true;
                } else {
                  isMe = false;
                }
                if (status == '1') {
                  isRead = true;
                } else {
                  isRead = false;
                }
                return isMe
                    ? GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                msg = data[i].id;
                                return AlertDialog(
                                  backgroundColor: Colors.black45,
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        FlatButton(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete_forever,
                                                size: 25.0,
                                                color: Colors.red,
                                              ),
                                              Text('Delete',
                                                  style: TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12.0,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                          onPressed: () {
                                            deleteMessage();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.content_copy,
                                                size: 25.0,
                                                color: Colors.lightBlue,
                                              ),
                                              Text('Copy',
                                                  style: TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12.0,
                                                      color: Colors.white))
                                            ],
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                        FlatButton(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.reply,
                                                size: 25.0,
                                                color: Colors.blueGrey,
                                              ),
                                              Text('Forward',
                                                  style: TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12.0,
                                                      color: Colors.white))
                                            ],
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Bubble(
                          style: styleMe,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data[i].description,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('$msg_date at $msg_time',
                                      style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 8.0,
                                          fontWeight: FontWeight.w700)),
                                  Icon(
                                      isRead
                                          ? Icons.done_all_outlined
                                          : Icons.done,
                                      size: 12.0,
                                      color: Colors.green.shade900)
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : Bubble(
                        style: styleSomebody,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data[i].description,
                                style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: 5.0),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '$msg_date at $msg_time',
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 8.0,
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          ],
                        ),
                      );
              },
            ),
          )),
          _buildMessageComposer()
        ],
      ),
    ));
  }
}



