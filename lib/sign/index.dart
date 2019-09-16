import 'package:flutter/material.dart';
import 'package:myapp/component/banner.dart';

import 'mx_btn.dart';

void main() => runApp(new SignIndex());

class SignIndex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('积分中心'),
      ),
      body: _Colums(),
    );
  }
}

class _Colums extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new _Top1(),
        new Container(
          height: 200,
        ),
        new Container(
          height: 105,
        ),
        new BannerWidget(90, 'score'),
      ],
    );
  }
}

class _Top1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 40),
          width: 375,
          height: 160,
          color: Color(0xff8e9093),
          child: new Column(
            children: <Widget>[
              Text('可用积分', style: TextStyle(color: Colors.white, fontSize: 14),),
              Text('800', style: TextStyle(color: Colors.white, fontSize: 46),),
            ],
          ),
        ),
        new SignFloatBtnPage(),
      ],
    );
  }
}
