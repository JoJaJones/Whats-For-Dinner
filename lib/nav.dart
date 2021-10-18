import 'package:flutter/material.dart';
import 'package:whats_for_dinner/screens/pantry_screen.dart';
import 'package:whats_for_dinner/screens/planner_screen.dart';
import 'package:whats_for_dinner/screens/profile_screen.dart';
import 'package:whats_for_dinner/screens/search_screen.dart';

class Nav extends StatefulWidget {
  static const String id = 'nav_screens';
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedScreen = 0;
  List<Widget> _screenOptions = <Widget>[
    PantryScreen(),
    SearchScreen(),
    PlannerScreen(),
    ProfileScreen(),
  ];

  void _onNavTap(int index) {
    setState(() {
      _selectedScreen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('What\'s for Dinner?'),
        ),
        body: IndexedStack(
          index: _selectedScreen,
          children: _screenOptions,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.fastfood_sharp),
              label: 'Pantry',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Meal Plan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: 'User Profile',
            )
          ],
          currentIndex: _selectedScreen,
          onTap: _onNavTap,
        ));
  }
}
