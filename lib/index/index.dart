import 'package:flutter/material.dart';
import 'package:myapp/component/banner.dart';

import './category.dart';
import './goods.dart';
import '../bottomNavigationBar.dart';

import '../sign/sign_btn.dart';

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      BannerWidget(height:200, type:'new'),
                      new SignFloatBtnPage(),
                    ],
                  ),
                  CategoryWidget(),
                  Container(
                    padding: EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 8.0),
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
    );
  }
}
