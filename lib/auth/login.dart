import 'package:flutter/material.dart';
import 'package:apifm/apifm.dart' as Apifm;
import '../config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/AuthHandle.dart' as AuthHandle;
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter_qq/flutter_qq.dart';

import 'reset_pwd.dart';

void main() => runApp(LoginPage());

class LoginPage extends StatefulWidget {
  @override
  _LoginPageWidgetState createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPage> {
  //全局 Key 用来获取 Form 表单组件
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  String mobile;
  String password;

  var graphValidateCodeMap;

  @override
  void initState() {
    Apifm.init(apifmConfigSubDomain);
    super.initState();
  }

  forgetPassword () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgetPwdPage()),
    );
  }

  void processLoginSuccess (token, uid) async {
    // 登录成功后处理
    await AuthHandle.login(token, uid);
    Fluttertoast.showToast(msg: "登录成功!", gravity: ToastGravity.CENTER, fontSize: 14);
    Navigator.pop(context);
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
    if (password == null) {
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
    var res = await Apifm.loginMobile(mobile, password, deviceId, deviceName);
    if (res['code'] == 0) {
      processLoginSuccess (res['data']['token'], res['data']['uid']);
    } else {
      Fluttertoast.showToast(msg: res['msg'], gravity: ToastGravity.CENTER, fontSize: 14);
    }
  }

  loginQQ () async {
    const appid = '1105644913';
    await FlutterQq.registerQQ(appid);
    var qqResult = await FlutterQq.login();    
    if (qqResult.code == 0) {
      // 登录成功
      Fluttertoast.showToast(msg: '授权成功', gravity: ToastGravity.CENTER, fontSize: 14);
      var res = await Apifm.loginQQConnect(appid, qqResult.response['openid'], qqResult.response['accessToken']);
      if (res['code'] == 10000) {
        // 用户不存在，则先注册
        await Apifm.registerQQConnect({
          'oauthConsumerKey': appid,
          'openid': qqResult.response['openid'],
          'accessToken': qqResult.response['accessToken'],
        });
        // 注册完后重新登录
        res = await Apifm.loginQQConnect(appid, qqResult.response['openid'], qqResult.response['accessToken']);
      }
      if (res['code'] != 0) {
        // 登录失败
        Fluttertoast.showToast(msg: res['msg'], gravity: ToastGravity.CENTER, fontSize: 14);
        return;
      }
      processLoginSuccess (res['data']['token'], res['data']['uid']); // 登录成功后的业务处理
    } else if (qqResult.code == 1) {
      // 授权失败
      Fluttertoast.showToast(msg: qqResult.message, gravity: ToastGravity.CENTER, fontSize: 14);
    } else {
      // 用户取消授权
      Fluttertoast.showToast(msg: '已取消', gravity: ToastGravity.CENTER, fontSize: 14);
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
            padding: EdgeInsets.all(15),
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
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: 
                  new MaterialButton(                    
                      padding: EdgeInsets.all(15),
                      color: Colors.red[400],
                      textColor: Colors.white,
                      child: new Text('QQ一键登录'),
                      onPressed: loginQQ,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
