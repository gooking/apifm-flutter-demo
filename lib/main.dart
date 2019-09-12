import 'package:flutter/material.dart';
import 'start_page.dart';
import 'config.dart';
import 'routes.dart';

void main() => runApp(new Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appTitle,
      routes: initAppRoutes(),
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new StartPage(),
    );
  }
}
