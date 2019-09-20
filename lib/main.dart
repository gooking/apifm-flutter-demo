import 'package:flutter/material.dart';
import 'store/store.dart';
import 'package:provider/provider.dart';
import 'start_page.dart';
import 'config.dart';
import 'routes.dart';

void main() {
  runApp(
    Provider<int>.value(
      value: 48,
      child: ChangeNotifierProvider.value(
        value: ApplicationData(),
        child: Main(),
      ),
    ),
  );
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appTitle,
      routes: initAppRoutes(),
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new StartPage(), //GoodsDetailPage StartPage
    );
  }
}
