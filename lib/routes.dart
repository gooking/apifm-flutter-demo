import 'package:flutter/material.dart';

import 'auth/login.dart';
import 'index/index.dart';

Map<String, WidgetBuilder> initAppRoutes() {
  return {
    '/login': (context) => LoginPage(),
    '/index': (context) => IndexPage(),
  };
}
