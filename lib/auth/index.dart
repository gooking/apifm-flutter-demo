import 'package:flutter/material.dart';

import 'package:apifm/apifm.dart' as Apifm;
import '../config.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';

import 'register.dart';
import 'login.dart';

void main() => runApp(new AuthIndexPage());

class AuthIndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Index Page',
      color: Colors.white,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            SizedBox(height: 120),
            _Logo(),
            Expanded(
              child: _Image(),
            ),
            _Foot(),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 750,
      height: 80,
      child: FlutterLogo(),
    );
  }
}

class _Image extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 750,
      child: Center(
        child: _ImagePic(),
      ),
    );
  }
}

class _ImagePic extends StatefulWidget {
  @override
  _ImagePicState createState() => new _ImagePicState();
}

class _ImagePicState extends State<_ImagePic> {
  String picUrl;

  @override
  void initState() {
    super.initState();
    // 初始化 apifm 插件
    Apifm.init(apifmConfigSubDomain);
    // 读取系统参数设置
    Apifm.queryConfigValue('AUTH_INDEX_PIC').then((res) {
      if (res['code'] == 0) {
        setState(() {
          picUrl = res['data'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (picUrl == null) {
      return Center(
        child: Loading(indicator: BallPulseIndicator(), size: 100.0),
      );
    } else {
      return Image.network(
        picUrl,
        fit: BoxFit.cover,
      );
    }
  }
}

class _Foot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 750,
      height: 200,
      child: Column(
        children: <Widget>[
          SizedBox(height: 30),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            color: Colors.red,
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
            child: Text('已有账号, 立即登录', style: TextStyle(fontSize: 16)),
          ),
          SizedBox(height: 20),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPage()),
              );
            },
            color: Colors.grey,
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
            child: const Text('没有账号, 我要注册', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
