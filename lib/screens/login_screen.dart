import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_plus/screens/dashboard.dart';
import 'package:http/http.dart' as http;

String username,
    firstName,
    lastName,
    telephone,
    address,
    date,
    patient_id,
    age,
    admin_id,
    password,
    profile;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  String message = '';
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();


  Widget _buildUsernameTF() {
    return Container(
      padding: EdgeInsets.only(top: 4.0, left: 16.0, right: 16.0, bottom: 4.0),
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Color.fromRGBO(4, 131, 184, .9)),
      child: TextFormField(
          controller: usernameController,
          cursorColor: Colors.white,
          decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Enter your Username'),
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: 'Lato',
              color: Colors.white,
              fontSize: 20.0)),
    );
  }

  Widget _buildPasswordTF() {
    return Container(
      padding: EdgeInsets.only(top: 4.0, left: 16.0, right: 16.0, bottom: 4.0),
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Color.fromRGBO(4, 131, 184, .9)),
      child: TextField(
          controller: passwordController,
          obscureText: true,
          cursorColor: Colors.white,
          decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.lock, color: Colors.white),
              hintText: 'Enter your Password'),
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: 'Lato',
              color: Colors.white,
              fontSize: 20.0)),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0, right: 10.0),
        child: FlatButton(
          onPressed: () {
            debugPrint('');
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w300),
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMe() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Row(
        children: [
          Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: _rememberMe,
                checkColor: Colors.green,
                activeColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value;
                  });
                },
              )),
          Text(
            'Remember me',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w200),
          )
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: MediaQuery.of(context).size.width * 0.7,
      child: RaisedButton(
        elevation: 5.0,
        padding: EdgeInsets.all(15.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
              letterSpacing: 1.5,
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Color(0xFF527DAA)),
        ),
        onPressed: () => login(),
      ),
    );
  }

  Widget _buildSignWith() {
    return Column(
      children: [
        Text('- OR -',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400)),
        SizedBox(height: 10.0),
        Text(
          ' Sign In with ',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400),
        )
      ],
    );
  }

  Widget _buildSocialMediaIcons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0)
                ],
                image: DecorationImage(
                    image: AssetImage('assets/images/google_.png'))),
          ),
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0)
                ],
                image: DecorationImage(
                    image: AssetImage('assets/images/Twitter_Logo_Blue.png'))),
          ),
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0)
                ],
                image: DecorationImage(
                    image: AssetImage('assets/images/face.png'))),
          ),
        ],
      ),
    );
  }

  Future<List> login() async {
    final response = await http
        .post('http://192.168.43.122/healthplus/healthplus_mob/login.php', body: {
      "username": usernameController.text,
      "password": passwordController.text,
    });
    var dataUser = json.decode(response.body);

    if (dataUser.length == 0) {
      setState(() {
        message = "Username or Password Incorrect";
        usernameController.text = '';
        passwordController.text = '';
      });
    } else {
      if (dataUser[0]['status'] == '1') {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(),
            ));
        usernameController.text = '';
        passwordController.text = '';
      } else if (dataUser[0]['status'] == '0') {
        Navigator.pushReplacementNamed(context, '/otherPage');
      }
      setState(() {
        username = dataUser[0]['username'];
        patient_id = dataUser[0]['id'];
        firstName = dataUser[0]['first_name'];
        lastName = dataUser[0]['last_name'];
        age = dataUser[0]['age'];
        telephone = dataUser[0]['telephone'];
        address = dataUser[0]['address'];
        admin_id = dataUser[0]['admin_id'];
        profile = dataUser[0]['profile'];
        date = dataUser[0]['c_date'];
      });
    }
    return dataUser;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color.fromRGBO(4, 131, 184, .9),
                title: Center(
                    child: Icon(
                  Icons.warning,
                  size: 60,
                  color: Colors.white,
                )),
                content: Text(
                  "Are you sure you want to exit?",
                  style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("YES",
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    onPressed: () {
                      exit(0);
                    },
                  ),
                  FlatButton(
                    child: Text("NO",
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                    child: Card(
                      elevation: 30.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      color: Color.fromRGBO(4, 131, 184, .8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10.0),
                          Text(
                            'Sign In',
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 40.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 40.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Form(
                                  child: Column(
                                children: [
                                  _buildUsernameTF(),
                                  SizedBox(height: 10.0),
                                  _buildPasswordTF(),
                                  _buildForgotPassword(),
                                  _buildRememberMe(),
                                  _buildLoginBtn(),
                                  Text(
                                    message,
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w900,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 18.0,
                                        fontFamily: 'Lato'),
                                  ),
                                  _buildSignWith(),
                                  _buildSocialMediaIcons(),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: "Dont't have an account?",
                                          style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontWeight: FontWeight.w300)),
                                      TextSpan(
                                          text: " Sign Up",
                                          style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontWeight: FontWeight.bold))
                                    ]),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
