import 'dart:async';

import 'package:flutter/material.dart';
import '../component/banner.dart';
import 'package:apifm/apifm.dart' as Apifm;
import '../config.dart';
import 'package:flutter_html/flutter_html.dart';

const int goodsId = 6765; // 测试时候写死调试

class GoodsDetailPage extends StatefulWidget {
  @override
  _GoodsDetailPageState createState() => _GoodsDetailPageState();
}

class _GoodsDetailPageState extends State<GoodsDetailPage> {
  ScrollController _controller = new ScrollController();
  double curOffset = 0; // 当前滚动条的位置
  bool showToTopBtn = false; //是否显示“返回到顶部”按钮
  List<String> pics;
  Map<String, dynamic> goodsDetail = {'name': ''};
  String content = '';

  GlobalKey aaa = GlobalKey();



  @override
  void initState() {
    super.initState();
    Apifm.init(apifmConfigSubDomain);
    fetchGoodsDetail();
    _controller.addListener(() {
      curOffset = _controller.offset;
      if (_controller.offset < 1000 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_controller.offset >= 1000 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
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
        content = res['data']['content'];
      });
    }
  }

  scrollToAaa () async {
    // _controller.animateTo(999999999999,
    //     duration: Duration(milliseconds: 300),
    //     curve: Curves.ease
    // );
    curOffset += 1000;
    await _controller.animateTo(curOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease
    );
    
    if (aaa.currentContext == null) {
      // await Future.delayed(Duration(milliseconds: 200));
      await scrollToAaa ();
    } else {
      RenderBox box = aaa.currentContext.findRenderObject();
      Offset offset = box.localToGlobal(Offset.zero);
      print(curOffset);
      print(offset);
      // await _controller.animateTo(offset.dy,
      //     duration: Duration(milliseconds: 300),
      //     curve: Curves.ease
      // );
    }    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          DefaultTabController(
            length: 3,
            child: new CustomScrollView(
              controller: _controller,
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
                    background: pics == null
                        ? Container()
                        : BannerWidget(
                            height: 375,
                            imagesList: pics,
                          ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: StickyTabBarDelegate(
                    child: TabBar(labelColor: Colors.black, tabs: [
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
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            goodsDetail['name'],
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  goodsDetail['characteristic'] ?? '精选好货',
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                              ),
                              Text(
                                '￥' + goodsDetail['minPrice'].toString(),
                                style:
                                    TextStyle(color: Colors.red, fontSize: 24),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '￥' + goodsDetail['originalPrice'].toString(),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                color: Colors.grey,
                                width: 50,
                                height: 1,
                              ),
                              Container(
                                child: Text(
                                  '   详情   ',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ),
                              Container(
                                color: Colors.grey,
                                width: 50,
                                height: 1,
                              ),
                            ],
                          ),
                        ),
                        Html(
                          data: content,
                          //Optional parameters:
                          padding: EdgeInsets.all(8.0),
                          backgroundColor: Colors.white,
                          defaultTextStyle: TextStyle(fontFamily: 'serif'),
                          linkStyle: const TextStyle(
                            color: Colors.redAccent,
                          ),
                          onLinkTap: (url) {
                            // open url in a webview
                          },
                          onImageTap: (src) {
                            // Display the image in large form.
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          !showToTopBtn? Container() : Positioned(
            bottom: 180,
            right: 0,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: scrollToAaa,
              child: Container(
                decoration: new BoxDecoration(
                            color: Color(0x999E9E9E), shape: BoxShape.circle),
                width: 40,
                height: 40,
                child: Icon(Icons.keyboard_arrow_up, color: Colors.white),
              ),
            ),
          )
        ],
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
