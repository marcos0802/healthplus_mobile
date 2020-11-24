import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:health_plus/screens/settings.dart';
import 'package:health_plus/screens/views/appointments.dart';
import 'package:health_plus/screens/views/chats.dart';
import 'package:health_plus/screens/views/home.dart';
import 'package:health_plus/screens/views/notification.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool showFab = true;

  @override
  void initState() {
    _tabController = TabController(vsync: this, initialIndex: 1, length: 4);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        showFab = true;
      } else {
        showFab = false;
      }
    });
    super.initState();
  }

  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    var _value;
    return new AppBar(
        leading: Icon(Icons.menu),
        elevation: 0.0,
        title: new Text(
          'HealthPlus',
          style: TextStyle(
              fontFamily: 'Lato', fontWeight: FontWeight.w200, fontSize: 24.0, letterSpacing: 2),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(
                icon: Icon(
              Icons.home,
              size: 30.0,
            )),
            Tab(
              icon: Icon(Icons.message, size: 30.0),
            ),
            Tab(
              icon: Icon(Icons.date_range, size: 30.0),
            ),
            Tab(
              icon: Icon(Icons.notifications, size: 30.0),
            )
          ],
        ),
        actions: [
          searchBar.getSearchAction(context),
          PopupMenuButton(
            color: Color(0xFF144566),
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              setState(() {
               _value = value;
              });

            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: FlatButton(
                    child: Text('Settings',
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 17,
                            color: Colors.white)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Settings(),
                          ));
                    }),
                value: 0,
              ),
              PopupMenuItem(
                child: FlatButton(
                    child: Text('Help & Feedback',
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 17,
                            color: Colors.white)),
                    onPressed: () {
                      //
                    }),
                value: 1,
              ),
              PopupMenuItem(
                child: FlatButton(
                    child: Text('About',
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 17,
                            color: Colors.white)),
                    onPressed: () {
                      //
                    }),
                value: 2,
              ),
            ],
          )
        ]);
  }

  void onSubmitted(String value) {
    setState(() => _scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text(
          'You are searching for $value?',
          style: TextStyle(fontSize: 15.0, fontFamily: 'Lato'),
        ))));
  }

  _DashboardState() {
    searchBar = new SearchBar(
      inBar: false,
      buildDefaultAppBar: buildAppBar,
      setState: setState,
      onSubmitted: onSubmitted,
      onCleared: () {},
      onClosed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: searchBar.build(context),
        key: _scaffoldKey,
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Home(),
            Chats(),
            Appointments(),
            Notifications(),
          ],
        ));
  }
}
