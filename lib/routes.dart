import 'package:flutter/material.dart';
import 'package:myapp/sign/index.dart';

import 'auth/index.dart';
import 'auth/login.dart';
import 'auth/register.dart';
import 'auth/reset_pwd.dart';
import 'index/index.dart';

Map<String, WidgetBuilder> initAppRoutes() {
  return {
    '/index': (context) => IndexPage(),
    '/auth': (context) => AuthIndexPage(),
    '/login': (context) => LoginPage(),
    '/reg': (context) => RegisterPage(),
    '/forget-pwd': (context) => ForgetPwdPage(),
    '/score/index': (context) => SignIndex(),
  };
}
