import 'package:flutter/material.dart';
import 'index/index.dart';
import 'auth/index.dart';

class FootWidget extends StatefulWidget {
  @override
  _WidgetState createState() => new _WidgetState();
}

class _WidgetState extends State<FootWidget> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AuthIndexPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('首页'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          title: Text('Business'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.perm_identity),
          title: Text('我的'),          
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }
}
