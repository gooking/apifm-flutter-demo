import 'package:flutter/material.dart';
import 'package:myapp/component/banner.dart';
import 'package:apifm/apifm.dart' as Apifm;
import 'package:myapp/store/store.dart';
import '../utils/apis.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import 'mx_btn.dart';
import '../utils/AuthHandle.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignIndex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('积分中心'),
      ),
      body: Stack(
        children: <Widget>[
          _Colums(),
          _Sign(), // 签到的浮层
        ],
      ),
    );
  }
}

class _Colums extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _Top1(),
        SizedBox(
          height: 200,
        ),
        new _Useless(),
        SizedBox(
          height: 20,
        ),
        new BannerWidget(height:90, type:'score'),
      ],
    );
  }
}

class _Top1 extends StatefulWidget {
  @override
  _Top1State createState() => new _Top1State();
}

class _Top1State extends State<_Top1> {
  int userScore = 0;
  @override
  void initState() {
    super.initState();
    // 初始化 apifm 插件
    Apifm.init(apifmConfigSubDomain);
    // 读取用户积分
    ApiUtils().userAmount().then((userAmount) {
      if (userAmount != null) {
        this.setState((){
          userScore = userAmount['score'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _applicationData = Provider.of<ApplicationData>(context);
    if (_applicationData.userAmount != null) {
      userScore = _applicationData.userAmount['score'];
    }

    return Stack(
      children: <Widget>[
        new Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 40),
          width: 375,
          height: 200,
          color: Color(0xff8e9093),
          child: new Column(
            children: <Widget>[
              Text(
                '可用积分',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              Text(
                userScore.toString(),
                style: TextStyle(color: Colors.white, fontSize: 46),
              ),
            ],
          ),
        ),
        new SignFloatBtnPage(),
      ],
    );
  }
}

class _Useless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: new Column(
            children: <Widget>[
              Image.asset(
                'images/score_huiyuan.jpeg',
                width: 50,
                height: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '超级会员',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                '购物享双倍积分',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        Expanded(
          child: new Column(
            children: <Widget>[
              Image.asset(
                'images/score_gouwu.jpeg',
                width: 50,
                height: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '积分商城',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                '小积分大用处',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        Expanded(
          child: new Column(
            children: <Widget>[
              Image.asset(
                'images/score_cj.jpeg',
                width: 50,
                height: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '积分抽奖',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                '100%中奖',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}

class _Sign extends StatefulWidget {
  @override
  _SignState createState() => new _SignState();
}

class _SignState extends State<_Sign> {
  List<Widget> steps = [];
  var todayCheckedData;

  @override
  void initState() {
    super.initState();
    // 初始化 apifm 插件
    Apifm.init(apifmConfigSubDomain);
    // 读取签到规则
    scoreSignRules();
  }

  scoreSignRules() async {
    List<Widget> _steps = [];
    var _todayCheckedData;

    String token = await getLoginedToken();
    var logsRes = await Apifm.scoreSignLogs({
      'token': token,
      'page': '1',
      'pageSize': '1',
    });
    int continuous = 0; //连续签到天数
    if (logsRes['code'] == 0) {
      continuous = logsRes['data']['result'][0]['continuous'];
    }
    var res = await Apifm.scoreSignRules(); // 读取签到规则
    if (res['code'] == 0) {
      res['data'].forEach((entity) {
        _steps.add(Expanded(
          child: _Step(
            title: entity['continuous'].toString(),
            subTitle: '+' + entity['score'].toString(),
            active: continuous >= entity['continuous'],
          ),
        ));
      });
    }
    // 判断今天是否已签到，按钮显示样式
    res = await Apifm.scoreTodaySignedInfo(token);
    if (res['code'] == 0) {
      _todayCheckedData = res['data'];
    }
    setState(() {
      steps = _steps;
      todayCheckedData = _todayCheckedData;
    });
  }

  sign () async {
    
    if (1==1) {
      return;
    }
    String token = await getLoginedToken();
    var res = await Apifm.scoreSign(token); // 签到
    if (res['code'] == 0) {
      scoreSignRules();
    } else {
      Fluttertoast.showToast(msg: res['msg'], gravity: ToastGravity.CENTER, fontSize: 14);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _applicationData = Provider.of<ApplicationData>(context);
    return Positioned(
      width: 335,
      left: 20,
      top: 140,
      child: new ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Color(0xffecd5a7),
          child: Column(
            children: <Widget>[
              Container(
                width: 335,
                padding: EdgeInsets.all(10),
                child: Text('每日签到',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 10,
              ),
              new Row(
                children: steps,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: 335,
                  padding: EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: new FlatButton(                      
                      padding: EdgeInsets.all(15),
                      color: Colors.white,
                      disabledColor: Colors.grey[300],
                      child: new Text(
                        todayCheckedData == null ? '签 到' : '已连续签到${todayCheckedData['continuous']}天',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: todayCheckedData == null ? () async {
                        String token = await getLoginedToken(); 
                        var res = await Apifm.scoreSign(token); // 签到
                        if (res['code'] == 0) {
                          scoreSignRules();
                          var userAmount = await ApiUtils().userAmount();
                          _applicationData.setUserAmount(userAmount);
                        } else {
                          Fluttertoast.showToast(msg: res['msg'], gravity: ToastGravity.CENTER, fontSize: 14);
                        }
                      } : null,
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool active;
  @override
  const _Step({this.title = '', this.subTitle = '', this.active = false});
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                height: 3,
                color: Color(0xffd6b470),
              ),
            ),
            Expanded(
              flex: 4,
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipOval(
                  child: Container(
                    alignment: Alignment.center,
                    color: active ? Colors.white : Color(0xffd6b470),
                    child: Text(
                      active ? '√' : title,
                      style: TextStyle(color: active ? Color(0xffd6b470) : Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 3,
                color: Color(0xffd6b470),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Text(subTitle, style: TextStyle(color: Color(0xfffcf8f2))),
      ],
    );
  }
}
