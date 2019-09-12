import 'package:flutter/material.dart';
import 'package:apifm/apifm.dart' as Apifm;
import '../config.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login.dart';

void main() => runApp(RegisterPage());

// 这个 widget 作用这个应用的顶层 widget.
//这个 widget 是无状态的，所以我们继承的是 [StatelessWidget].
//对应的，有状态的 widget 可以继承 [StatefulWidget]
class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 我们想使用 material 风格的应用，所以这里用 MaterialApp
    return MaterialApp(
      // 移动设备使用这个 title 来表示我们的应用。具体一点说，在 Android 设备里，我们点击
      // recent 按钮打开最近应用列表的时候，显示的就是这个 title。
      title: 'Welcome to Flutter',
      // 应用的“主页”
      home: _RegisterPageWidget(),
    );
  }
}

class _RegisterPageWidget extends StatefulWidget {
  @override
  _RegisterPageWidgetState createState() => _RegisterPageWidgetState();
}

class _RegisterPageWidgetState extends State<_RegisterPageWidget> {
  //全局 Key 用来获取 Form 表单组件
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  String mobile;
  String imageCode;
  String smsCode;
  String password;

  var graphValidateCodeMap;

  @override
  void initState() {
    Apifm.init(apifmConfigSubDomain);
    changePicCode();
    super.initState();
  }

  void changePicCode() {
    setState(() {
      graphValidateCodeMap = Apifm.graphValidateCodeUrl();
    });
  }

  void showMessage(String name) {
    showDialog<Null>(
        context: context,
        child: new AlertDialog(content: new Text(name), actions: <Widget>[
          new FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: new Text('确定'))
        ]));
  }

  void getSmsCode() async {
    loginKey.currentState.save();
    if (mobile == null || mobile.trim().length < 11) {
      Fluttertoast.showToast(msg: "请输入手机号码", gravity: ToastGravity.CENTER, fontSize: 14);
      return;
    }
    if (imageCode == null || imageCode.trim().length < 4) {
      Fluttertoast.showToast(msg: "请输入图形验证码", gravity: ToastGravity.CENTER, fontSize: 14);
      return;
    }
    var res = await Apifm.smsValidateCode(mobile, graphValidateCodeMap['key'], imageCode);
    if (res['code'] == 0) {
      Fluttertoast.showToast(msg: "短信发送成功,请注意查收！", gravity: ToastGravity.CENTER, fontSize: 14);
    } else {
      Fluttertoast.showToast(msg: res['msg'], gravity: ToastGravity.CENTER, fontSize: 14);
      changePicCode();
    }
  }

  void regist() async {
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
    if (imageCode == null || imageCode.trim().length < 4) {
      Fluttertoast.showToast(msg: "请输入图形验证码", gravity: ToastGravity.CENTER, fontSize: 14);
      return;
    }
    if (smsCode == null || smsCode.trim().length < 4) {
      Fluttertoast.showToast(msg: "请输入短信验证码", gravity: ToastGravity.CENTER, fontSize: 14);
      return;
    }
    if (password == null || smsCode.trim().length < 1) {
      Fluttertoast.showToast(msg: "请输入登录密码", gravity: ToastGravity.CENTER, fontSize: 14);
      return;
    }
    var res = await Apifm.registerMobile({
      'mobile': mobile,
      'pwd': password,
      'code': smsCode
    });
    if (res['code'] == 0) {
      Fluttertoast.showToast(msg: "注册成功,请登录", gravity: ToastGravity.CENTER, fontSize: 14);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      Fluttertoast.showToast(msg: res['msg'], gravity: ToastGravity.CENTER, fontSize: 14);
      changePicCode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('注册新账号'),
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
              autovalidate: true,
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
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: '图片验证码',
                            prefixIcon: Icon(Icons.image),
                          ),
                          //当 Form 表单调用保存方法 Save时回调的函数。
                          onSaved: (value) {
                            imageCode = value;
                          },
                          // 当用户确定已经完成编辑时触发
                          onFieldSubmitted: (value) {},
                        ),
                      ),
                      Image.network(
                        graphValidateCodeMap['imageUrl'],
                        fit: BoxFit.fitHeight,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: '短信验证码',
                            prefixIcon: Icon(Icons.security),
                          ),
                          //当 Form 表单调用保存方法 Save时回调的函数。
                          onSaved: (value) {
                            smsCode = value;
                          },
                          // 当用户确定已经完成编辑时触发
                          onFieldSubmitted: (value) {},
                        ),
                      ),
                      RaisedButton(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "获取验证码",
                          style: TextStyle(fontSize: 12),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: getSmsCode,
                      ),
                    ],
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
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "立即注册",
                      style: TextStyle(fontSize: 18),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: regist,
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
