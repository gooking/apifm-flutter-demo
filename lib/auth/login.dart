import 'package:flutter/material.dart';
import 'package:apifm/apifm.dart' as Apifm;
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:io';
import 'package:device_info/device_info.dart';

import 'reset_pwd.dart';

void main() => runApp(LoginPage());

// 这个 widget 作用这个应用的顶层 widget.
//这个 widget 是无状态的，所以我们继承的是 [StatelessWidget].
//对应的，有状态的 widget 可以继承 [StatefulWidget]
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 我们想使用 material 风格的应用，所以这里用 MaterialApp
    return MaterialApp(
      // 移动设备使用这个 title 来表示我们的应用。具体一点说，在 Android 设备里，我们点击
      // recent 按钮打开最近应用列表的时候，显示的就是这个 title。
      title: 'Welcome to Flutter',
      // 应用的“主页”
      home: _LoginPageWidget(),
    );
  }
}

class _LoginPageWidget extends StatefulWidget {
  @override
  _LoginPageWidgetState createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<_LoginPageWidget> {
  //全局 Key 用来获取 Form 表单组件
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  String mobile;
  String password;

  var graphValidateCodeMap;

  @override
  void initState() {
    Apifm.init('gooking');
    super.initState();
  }

  forgetPassword () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgetPwdPage()),
    );
  }

  void login() async {
    var loginForm = loginKey.currentState;
    //验证 Form表单
    if (!loginForm.validate()) {
      Fluttertoast.showToast(msg: "请认真填写表单", gravity: ToastGravity.CENTER, fontSize: 14);
      return;
    }
    loginForm.save();
    if (mobile == null || mobile.trim().length < 11) {
      Fluttertoast.showToast(msg: "请输入手机号码", gravity: ToastGravity.CENTER, fontSize: 14);
      return;
    }
    if (password == null || password.trim().length < 4) {
      Fluttertoast.showToast(msg: "请输入登录密码", gravity: ToastGravity.CENTER, fontSize: 14);
      return;
    }
    // 读取手机信息
    String deviceId, deviceName;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isIOS){
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
      deviceName = iosInfo.name;
    } else if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
      deviceName = androidInfo.display;
    }
    print('deviceId: $deviceId, deviceName: $deviceName');
    var res = await Apifm.login_mobile(mobile, password, deviceId, deviceName);
    if (res['code'] == 0) {
      Fluttertoast.showToast(msg: "登录成功!", gravity: ToastGravity.CENTER, fontSize: 14);
    } else {
      Fluttertoast.showToast(msg: res['msg'], gravity: ToastGravity.CENTER, fontSize: 14);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('登录账号'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Form(
              //设置globalKey，用于后面获取FormState
              key: loginKey,
              //开启自动校验
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: '输入手机号',
                      hintText: "用于接收短信验证码",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                      prefixIcon: Icon(Icons.person),
                    ),
                    //当 Form 表单调用保存方法 Save时回调的函数。
                    onSaved: (value) {
                      mobile = value;
                    },
                    // 当用户确定已经完成编辑时触发
                    onFieldSubmitted: (value) {},
                  ),                  
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: '请输入密码',
                      hintText: '你的登录密码',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    //是否是密码
                    obscureText: true,
                    onSaved: (value) {
                      password = value;
                    },
                  ),
                  new Align(
                    alignment: FractionalOffset.centerRight,
                    child: new FlatButton(                      
                      padding: EdgeInsets.all(0),
                      child: new Text('忘记登录密码？'),
                      onPressed: forgetPassword,
                    )
                  ),                  
                ],
              ),
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: 
                  new MaterialButton(
                      padding: EdgeInsets.all(15),
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: new Text('立即登录'),
                      onPressed: login,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
