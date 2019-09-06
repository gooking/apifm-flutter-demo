import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:apifm/apifm.dart' as Apifm;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'index.dart';

void main() => runApp(new StartPage());

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Apifm HelloWorld',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> imagesList = [];

  @override
  void initState () {
    super.initState();
    // 初始化 apifm 插件
    Apifm.init("gooking");
    // 读取启动图片数据
    banners();
  }

  banners () async {
    var res = await Apifm.banners();
    if (res['code'] == 0) {
      List<String> _imagesList = [];
      res['data'].forEach((pic) {
        _imagesList.add(pic['picUrl']);
      });
      setState(() {
        imagesList = _imagesList;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (imagesList.length == 0) {
      return new Scaffold(
        body:  Container(
          color: Colors.grey,
          child: Center(
            child: Loading(indicator: BallPulseIndicator(), size: 100.0),
          ),
        ),
      );
    } else {
      return new Scaffold(
        body:  new Swiper(
          itemBuilder: (BuildContext context,int index){
            return new Image.network(imagesList[index],fit: BoxFit.cover,);
          },
          itemCount: imagesList.length,
          pagination: new SwiperPagination(),
          onTap: (index) {
            print(index); // 可以根据是否是最后一张图片，来跳转至主界面，一般会在最后一张图片上面设置一个按钮元素，引导用户去点击
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => IndexPage()),
            );
          },
        ),
      );
    }
    
  }
}