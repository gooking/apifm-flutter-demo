import 'package:apifm/apifm.dart' as Apifm;
import '../config.dart';
import './AuthHandle.dart';

class ApiUtils {
  ApiUtils() {
    Apifm.init(apifmConfigSubDomain);
  }

  /// 获取用户资产
  userAmount() async {
    String token = await getLoginedToken();
    var res = await Apifm.userAmount(token);
    if (res['code'] == 0) {
      return res['data'];
    }
    return null;
  }

  /// 获取积分明细
  scoreLogs(token, behavior, page, pageSize) async {
    String token = await getLoginedToken();
    var res = await Apifm.scoreLogs({'token': token,'behavior': behavior, 'page': page, 'pageSize': pageSize});
    if (res['code'] == 0) {
      return res['data'];
    }
    return null;
  }
}
