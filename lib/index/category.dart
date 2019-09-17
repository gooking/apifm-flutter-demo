import 'package:flutter/material.dart';
import 'package:apifm/apifm.dart' as Apifm;
import '../config.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';

class CategoryWidget extends StatefulWidget {
  @override
  _WidgetState createState() => new _WidgetState();
}

class _WidgetState extends State<CategoryWidget> {
  List<Widget> buildGridTileList = [];

  @override
  void initState() {
    super.initState();
    // 初始化 apifm 插件
    Apifm.init(apifmConfigSubDomain);
    // 读取启动图片数据
    category();
  }

  category() async {
    var res = await Apifm.goodsCategory();
    if (res['code'] == 0) {
      List<Widget> _buildGridTileList = [];
      res['data'].forEach((entity) {
        _buildGridTileList.add(new Column(          
          children: <Widget>[
            Container(
              width: 45,
              height: 45,
              child: Image.network(
                entity['icon'],
                fit: BoxFit.cover,
              ),
            ),
            new Expanded(
              child: Text(entity['name']),
            ),
          ],
        ));
      });
      setState(() {
        buildGridTileList = _buildGridTileList;
      });
    }
  }

  bannerClick(index) {
    print(index);
  }

  @override
  Widget build(BuildContext context) {
    if (buildGridTileList.length == 0) {
      return new Container(
        color: Colors.grey,
        child: Center(
          child: Loading(indicator: BallPulseIndicator(), size: 100.0),
        ),
      );
    } else {
      return new Container(
          width: 380,
          height: 170,
          margin: EdgeInsets.only(top: 20),
          child: new GridView.count(
            //横轴数量 这里的横轴就是x轴 因为方向是垂直的时候 主轴是垂直的
            crossAxisCount: 5,
            padding: const EdgeInsets.all(4.0),
            //主轴间隔
            mainAxisSpacing: 20.0,
            //横轴间隔
            crossAxisSpacing: 4.0,
            children: buildGridTileList,
          ));
    }
  }
}
