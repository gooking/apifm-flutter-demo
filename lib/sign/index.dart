import 'package:flutter/material.dart';

void main() => runApp(new SignIndex());

class SignIndex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter layout demo'),
      ),
      body: Center(
        child: Text('Hello World11'),
      ),
    );
  }
}
