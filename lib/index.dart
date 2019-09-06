import 'package:flutter/material.dart';
import 'start_page.dart';

void main() => runApp(new IndexPage());

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter layout demo'),
        ),
        body: Center(
          child: Text('this is main page!'),
        ),
      ),
    );
  }
}