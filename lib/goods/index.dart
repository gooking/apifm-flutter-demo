import 'package:flutter/material.dart';
import '../component/banner.dart';
import 'package:apifm/apifm.dart' as Apifm;
import '../config.dart';

const int goodsId = 6765; // 测试时候写死调试

class GoodsDetailPage extends StatefulWidget {
  @override
  _GoodsDetailPageState createState() => _GoodsDetailPageState();
}

class _GoodsDetailPageState extends State<GoodsDetailPage> {
  List<String> pics;
  Map<String, dynamic> goodsDetail = {
    'name': ''
  };
  @override
  void initState() {
    super.initState();
    Apifm.init(apifmConfigSubDomain);
    fetchGoodsDetail();
  }

  void fetchGoodsDetail() async {    
    var res = await Apifm.goodsDetail(goodsId);
    if (res['code'] == 0) {
      List<String> _pics = [];
      res['data']['pics'].forEach((ele) {
        _pics.add(ele['pic']);
      });

      setState(() {
        goodsDetail = res['data']['basicInfo'];
        pics = _pics;
      });
    }
    print(res);
    print(goodsDetail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: new CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text(goodsDetail['name']),
              centerTitle: true,
              leading: Container(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    decoration: new BoxDecoration(
                        color: Color(0xaa9E9E9E), shape: BoxShape.circle),
                    child: BackButton(),
                  )),
              actions: [
                Container(
                  decoration: new BoxDecoration(
                    color: Color(0xaa9E9E9E),
                    shape: BoxShape.circle,
                  ),
                  width: 40,
                  height: 40,
                  child: Icon(Icons.home),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: new BoxDecoration(
                    color: Color(0xaa9E9E9E),
                    shape: BoxShape.circle,
                  ),
                  width: 40,
                  height: 40,
                  child: Icon(Icons.share),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
              pinned: true,
              expandedHeight: 375,
              flexibleSpace: FlexibleSpaceBar(
                background: pics == null ? Container() : BannerWidget(
                  height: 375,
                  imagesList: pics,
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,              
              delegate: StickyTabBarDelegate(
                child: TabBar(
                  labelColor: Colors.black,
                  tabs: [
                  Tab(text: '商品'),
                  Tab(text: '详情'),
                  Tab(text: '评价'),
                ]),
              ),
            ),
            new SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: new SliverList(
                delegate: new SliverChildListDelegate(
                  <Widget>[
                    Container(
                      width: 375,
                      height: 375,
                      color: Colors.orange,
                      child: TabBarView(
                        children: <Widget>[
                          Text('tab1'),
                          Text('tab2'),
                          Text('tab3'),
                        ],
                      ),
                    ),
                    Container(
                      height: 300,
                      color: Colors.red[50],
                    ),
                    Container(
                      height: 300,
                      color: Colors.red[100],
                    ),
                    Container(
                      height: 300,
                      color: Colors.red[200],
                    ),
                    Container(
                      height: 300,
                      color: Colors.red[300],
                    ),
                    Container(
                      height: 300,
                      color: Colors.red[400],
                    ),
                    Container(
                      height: 300,
                      color: Colors.red[500],
                    ),
                    Text('data'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  StickyTabBarDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // print('shrinkOffset: $shrinkOffset ,overlapsContent : $overlapsContent');
    return Container(
      color: Colors.white,
      child: this.child,
    );
  }

  @override
  double get maxExtent => this.child.preferredSize.height;

  @override
  double get minExtent => this.child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
