import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'login_screen.dart';
import 'package:health_plus/screens/views/appointments.dart';
class Settings extends StatefulWidget {
  @override
  SettingsState createState() {
    return new SettingsState();
  }
}

class SettingsState extends State<Settings> {
  TextEditingController usernameController;
  TextEditingController passwordController;
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController ageController;
  TextEditingController telephoneController;
  TextEditingController addressController;
  TextEditingController idController;

  @override
  void initState() {
    usernameController = new TextEditingController(text: '$username');
    passwordController = new TextEditingController(text: '$password');
    idController = new TextEditingController(text: '$patient_id');
    firstNameController = new TextEditingController(text: '$firstName');
    lastNameController = new TextEditingController(text: '$lastName');
    ageController = new TextEditingController(text: '$age');
    telephoneController = new TextEditingController(text: '$telephone');
    addressController = new TextEditingController(text: '$address');
    super.initState();
  }

  void edit() {
    var url = "http://192.168.43.122/healthplus_mob/editInfo.php";
    http:
    post(url, body: {
      'id': idController.text,
      'firstname': firstNameController.text,
      'lastname': lastNameController.text,
      'age': ageController.text,
      'telephone': telephoneController.text,
      'address': addressController.text,
    });
  }

  Future<List> login() async {
    final response = await http.post(
        'http://192.168.43.122/healthplus/healthplus_mob/login.php',
        body: {
          "username": usernameController.text,
          "password": passwordController.text,
        });
    var dataUser = json.decode(response.body);

    if (dataUser.length == 0) {
      setState(() {
        usernameController.text = '';
        passwordController.text = '';
      });
    } else {
      setState(() {
        username = dataUser[0]['username'];
        patient_id = dataUser[0]['id'];
        firstName = dataUser[0]['first_name'];
        lastName = dataUser[0]['last_name'];
        age = dataUser[0]['age'];
        telephone = dataUser[0]['telephone'];
        address = dataUser[0]['address'];
        admin_id = dataUser[0]['admin_id'];
        date = dataUser[0]['c_date'];
        profile = dataUser[0]['profile'].toString();
      });
    }
    return dataUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: new Text(
            'Settings',
            style: TextStyle(
                fontWeight: FontWeight.w200,
                letterSpacing: 2,
                fontSize: 22.0,
                fontFamily: 'Lato'),
          ),
          centerTitle: true,
          elevation: 0.0,
          actions: [Icon(Icons.tune)]),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: RefreshIndicator(
          child: ListView(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  CircleAvatar(
                    radius: 100.0,
                    backgroundImage: profileImage().image,
                  ),
                  Text(
                    '$firstName $lastName',
                    style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2),
                  ),
                  Divider(),
                  Container(
                    color: Colors.black12,
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Spacer(),
                        Container(
                          child: Column(
                            children: [
                              Container(
                                width: 60.0,
                                height: 60.0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.alarm,
                                    size: 50.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              Text(
                                '235',
                                style: TextStyle(
                                    color: Colors.green.shade900,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Lato'),
                              ),
                              Text(
                                'Reminders received',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Lato'),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          child: Column(
                            children: [
                              Container(
                                width: 60.0,
                                height: 60.0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.date_range,
                                    size: 50.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              Text(
                                '234',
                                style: TextStyle(
                                    color: Colors.green.shade900,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Lato'),
                              ),
                              Text(
                                'Appointments',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Lato'),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          child: Column(
                            children: [
                              Container(
                                width: 60.0,
                                height: 60.0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.notifications_none_rounded,
                                    size: 50.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              Text(
                                '235',
                                style: TextStyle(
                                    color: Colors.green.shade900,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Lato'),
                              ),
                              Text(
                                'Notifications',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Lato'),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.black12,
                          padding: EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Update Info',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Lato')),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.account_circle),
                              iconSize: 25.0,
                              color: Theme.of(context).primaryColor,
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: firstNameController,
                                decoration:
                                    InputDecoration(hintText: 'FirstName'),
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return firstName;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: lastNameController,
                                decoration:
                                    InputDecoration(hintText: 'LastName'),
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return lastName;
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.person),
                              iconSize: 25.0,
                              color: Colors.red,
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: usernameController,
                                enabled: false,
                                decoration:
                                    InputDecoration(hintText: 'Username'),
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return username;
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.cake),
                              iconSize: 25.0,
                              color: Colors.brown.shade500,
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: ageController,
                                decoration: InputDecoration(hintText: 'Age'),
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return age;
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.phone_iphone),
                              iconSize: 25.0,
                              color: Theme.of(context).accentColor,
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: telephoneController,
                                decoration: InputDecoration(
                                    hintText: 'Telephone Number'),
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return telephone;
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.location_on),
                              iconSize: 25.0,
                              color: Colors.green.shade700,
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: addressController,
                                decoration:
                                    InputDecoration(hintText: 'Address'),
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return address;
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Center(
                          child: Row(
                            children: [
                              Spacer(),
                              RaisedButton(
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Lato',
                                      fontSize: 14.0),
                                ),
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  edit();
                                  login();
                                },
                              ),
                              SizedBox(width: 10.0),
                              RaisedButton(
                                child: Text('Discard',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Lato',
                                        fontSize: 14.0)),
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  firstNameController.text = firstName;
                                  lastNameController.text = lastName;
                                  ageController.text = age;
                                  telephoneController.text = telephone;
                                  addressController.text = address;
                                },
                              ),
                              Spacer()
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          onRefresh: () async {
            await login();
            firstNameController.text = firstName;
            lastNameController.text = lastName;
            ageController.text = age;
            telephoneController.text = telephone;
            addressController.text = address;
          },
        ),
      ),
    );
  }

  Image profileImage() {
    return Image.network(
        "http://192.168.43.122/healthplus/$profile".toString());
  }
}

