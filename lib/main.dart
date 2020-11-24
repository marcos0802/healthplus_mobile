import 'package:flutter/material.dart';
import 'package:health_plus/screens/login_screen.dart';

void main()=>runApp(HealthPlusApp());

class HealthPlusApp extends StatelessWidget {
  static Map<int, Color> color = {
    50: Color.fromRGBO(4, 131, 184, .1),
    100: Color.fromRGBO(4, 131, 184, .2),
    200: Color.fromRGBO(4, 131, 184, .3),
    300: Color.fromRGBO(4, 131, 184, .4),
    400: Color.fromRGBO(4, 131, 184, .5),
    500: Color.fromRGBO(4, 131, 184, .6),
    600: Color.fromRGBO(4, 131, 184, .7),
    700: Color.fromRGBO(4, 131, 184, .8),
    800: Color.fromRGBO(4, 131, 184, .9),
    900: Color.fromRGBO(4, 131, 184, 1),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HealthPlus',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF162A49, color),
        visualDensity: VisualDensity.comfortable,
      ),
      home: LoginScreen(),
    );
  }
}
