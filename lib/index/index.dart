import 'package:flutter/material.dart';

import './banner.dart';
import './category.dart';
import './goods.dart';
import '../bottomNavigationBar.dart';

import '../sign/btn.dart';

void main() => runApp(new IndexPage());

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Index page',
      home: Scaffold(
        body: new CustomScrollView(
          shrinkWrap: true,
          // 内容
          slivers: <Widget>[
            new SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: new SliverList(
                delegate: new SliverChildListDelegate(
                  <Widget>[
                    Stack(
                      children: <Widget>[
                        BannerWidget(),
                        new SignFloatBtnPage(),
                      ],
                    ),
                    CategoryWidget(),
                    Container(
                      padding: EdgeInsets.fromLTRB(3.0,8.0,3.0,8.0),
                      color: Colors.grey[300],
                      child: GoodsWidget(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: new FootWidget(),
      ),
    );
  }
}
