import 'package:flutter/material.dart';
import './sign/index.dart';
import './sign/logs.dart';

import 'auth/index.dart';
import 'auth/login.dart';
import 'auth/register.dart';
import 'auth/reset_pwd.dart';
import 'goods/index.dart';
import 'index/index.dart';

Map<String, WidgetBuilder> initAppRoutes() {
  return {
    '/index': (context) => IndexPage(),
    '/auth': (context) => AuthIndexPage(),
    '/login': (context) => LoginPage(),
    '/reg': (context) => RegisterPage(),
    '/forget-pwd': (context) => ForgetPwdPage(),
    '/score/index': (context) => SignIndex(),
    '/goods/detail': (context) => GoodsDetailPage(),
    '/logs': (context) => Logs(),
  };
}
