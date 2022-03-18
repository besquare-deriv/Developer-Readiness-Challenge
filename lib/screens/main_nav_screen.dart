// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_final_fields

import 'package:drc/screens/explorer_page.dart';
import 'package:drc/screens/history_page.dart';
import 'package:drc/screens/home_page.dart';
import 'package:drc/screens/market_list_page.dart';
import 'package:drc/screens/profile_page.dart';
import 'package:flutter/material.dart';

class NavigationPage extends StatefulWidget {
  String? value1;
  NavigationPage(this.value1, {Key? key}) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  String? value1;
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _pageScreens = <Widget>[
      HomePage(widget.value1!),
      ExplorePage(),
      MarketScreen(widget.value1!),
      HistoryScreen(widget.value1!),
      ProfilePage(widget.value1!),
    ];

    value1 = widget.value1;
    return GestureDetector(
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        //BODY below here
        body: Center(child: _pageScreens.elementAt(_selectedIndex)),
        // BOTTOMNAVIGATIONBAR below here

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: changePage,
          iconSize: 20,
          currentIndex: _selectedIndex,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          // elevation: 10.0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
                color: Colors.white,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/explore.png',
                height: 30,
                width: 30,
              ),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/plus.png',
                  height: 35,
                  width: 35,
                ),
                label: "Market"),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/history.png',
                height: 30,
                width: 30,
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/user.png',
                height: 30,
                width: 30,
              ),
              label: 'Profile',
            ),
          ],
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.white,
          showUnselectedLabels: true,
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
    // ignore: dead_code
  }

  void changePage(index) {
    FocusScope.of(context).requestFocus(new FocusNode());

    setState(() {
      _selectedIndex = index;
    });
  }
}
