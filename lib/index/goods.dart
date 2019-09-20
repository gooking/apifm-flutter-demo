import 'package:flutter/material.dart';
import 'package:apifm/apifm.dart' as Apifm;
import '../config.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';

class GoodsWidget extends StatefulWidget {
  @override
  _WidgetState createState() => new _WidgetState();
}

class _WidgetState extends State<GoodsWidget> {
  List<Widget> buildGridTileList = [];

  @override
  void initState() {
    super.initState();
    // 初始化 apifm 插件
    Apifm.init(apifmConfigSubDomain);
    // 读取启动图片数据
    goods();
  }

  goods() async {
    var res = await Apifm.goods();
    if (res['code'] == 0) {
      List<Widget> _buildGridTileList = [];
      res['data'].forEach((entity) {
        var goodsW = new Container(
          width: 172,
          child: new Column(
            children: <Widget>[
              new ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Container(
                  width: 172,
                  height: 172,
                  color: Colors.white,
                  child: Image.network(
                    entity['pic'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              new Container(
                width: 172,
                color: Color(0xFFf1ece2),
                padding: EdgeInsets.all(5),
                child: Text(
                  entity['characteristic'] ?? '精选好货',
                  maxLines: 1,
                  style: TextStyle(fontSize: 10, color: Color(0xFFaf9d79)),
                ),
              ),
              new Container(
                width: 172,
                color: Colors.white,
                padding: EdgeInsets.only(top: 10, left: 5),
                child: Text(
                  entity['name'],
                  maxLines: 1,
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
              new ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                child: new Container(
                  width: 172,
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 5, left: 4, bottom: 10),
                  child: Text(
                    '￥' + entity['minPrice'].toString(),
                    maxLines: 1,
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        );
        _buildGridTileList.add(GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/goods/detail');
          },
          child: goodsW,
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
      return new Wrap(
        spacing: 10, // gap between adjacent chips
        runSpacing: 10, // gap between lines
        children: buildGridTileList,
      );
    }
  }
}
