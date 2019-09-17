import 'package:flutter/material.dart';

class ApplicationData with ChangeNotifier {
  var _userAmount; // 用户资金
  get userAmount => _userAmount;
  void setUserAmount(userAmount) {
    print('setUserAmount1');
    this._userAmount = userAmount;
    print('setUserAmount2');
    notifyListeners();
  }
}