import 'package:flutter/material.dart';

import './banner.dart';
import '../bottomNavigationBar.dart';

void main() => runApp(new IndexPage());

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Index page',
      home: Scaffold(
        body: Column(
          children: <Widget>[
            BannerWidget(),
          ],
        ),
        bottomNavigationBar: new FootWidget(),
      ),
    );
  }
}
