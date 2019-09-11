import 'package:apifm/apifm.dart' as Apifm;
import '../config.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _TOKEN = "token";
const String _UID = "uid";

// 检测当前用户是否处于登录状态
checkLogined() async {
  Apifm.init(apifmConfigSubDomain);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString(_TOKEN);
  if (token == null) {
    return false;
  }
  // 判断 token 是否有效
  var res = await Apifm.checkToken(token);
  if (res['code'] == 0) {
    return true;
  }
  return false;
}

login(token, uid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(_TOKEN, token);
  await prefs.setInt(_UID, uid);
}

loginOut () async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(_TOKEN);
  await prefs.remove(_UID);
}