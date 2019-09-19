import 'package:flutter/material.dart';
import 'package:apifm/apifm.dart' as Apifm;
import '../config.dart';
import '../utils/apis.dart';
import '../utils/AuthHandle.dart';

class Logs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('积分明细')
      ),
      body: Column(
        children: <Widget>[
            _MyScore(),
            _TabBar(),
          ],
        )
    );
  }
}

class _MyScore extends StatefulWidget {
  @override
  _MyScoreState createState() => new _MyScoreState();
}

class _MyScoreState extends State<_MyScore>{
  int userScore = 0;

  @override
  void initState() {
    Apifm.init(apifmConfigSubDomain);
    super.initState();
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
    return Column(
      children: <Widget>[
        new Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 15.0),
          width: 375,
          height: 70,
          child: Row(
            children: <Widget>[
              Text('我的积分:', style: TextStyle(fontSize: 16.0, color: Colors.black),),
              Text(userScore.toString(), style: TextStyle(fontSize: 30.0, color: Colors.brown, fontWeight: FontWeight.w800),)
            ],
          ),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Color(0xffcccccc)))
          ),
        ),
      ],
    );
  }
}

class _TabBar extends StatefulWidget {
  @override
  _TabControllerPageState createState() => _TabControllerPageState();
}

class _TabControllerPageState  extends State<_TabBar> with SingleTickerProviderStateMixin {
  final  List<Tab> tabs = <Tab>[
    Tab(text: '积分收入',),
    Tab(text: '积分支出',)
  ];
  List items = [];

  TabController _tabController;

  @override
  void initState() { 
    _tabController = new TabController(
      vsync: this, // 固定写法
      length: tabs.length // 指定tab长度
    );
    // _tabController.addListener((){
    //   var index = _tabController.index;
    //   var previousIndex = _tabController.previousIndex;
    // });
    super.initState();
    // 读取积分明细
    getScoreLogs();
  }
  getScoreLogs() async {
    String token = await getLoginedToken();
    ApiUtils().scoreLogs(token, '0', '1', '10').then((scoreLogs) {
      if (scoreLogs != null) {
        this.setState((){
          items = scoreLogs['result'];
          print(items);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 375,
          child: Column(children: <Widget>[
            Container(
              width: 375,
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1.0, color: Colors.black26))
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.red,
                indicatorColor: Colors.red,
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor: Color(0xff666666),
                labelStyle: TextStyle(fontSize: 16.0),
                tabs: tabs,
              ),
            ),
            Container(
              width: 375,
              height: 387,
              padding: EdgeInsets.only(top: 30.0),
              color: Color(0xffeeeeee),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index){
                  return Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('${items[index]['typeStr']}'),
                        subtitle: Text('${items[index]['dateAdd']}'),
                        leading: Text('+${items[index]['score']}'),
                      ),
                    );
                },
              ),
            )
          ])
        )]
      );
  }
}

class ListViewAssets extends StatefulWidget {

  _ListViewAssetsState createState() => _ListViewAssetsState();
}

class _ListViewAssetsState extends State<ListViewAssets> {
  @override
  void initState() {
     
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: ListView.builder(
         itemCount: 1,
         itemBuilder: (BuildContext context, int index) {
         return ;
        },
       ),
    );
  }
}

class ListViewCost extends StatefulWidget {

  _ListViewCostState createState() => _ListViewCostState();
}

class _ListViewCostState extends State<ListViewCost> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: ListView.builder(
         itemCount: 1,
         itemBuilder: (BuildContext context, int index) {
         return ;
        },
       ),
    );
  }
}