import 'package:flutter/material.dart';
import '../utils/AuthHandle.dart' as AuthHandle;

class SignFloatBtnPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _click() async {
      bool _isLogined = await AuthHandle.checkLogined();
      if (_isLogined) {
        Navigator.pushNamed(context, '/score/index');
      } else {
        Navigator.pushNamed(context, '/login');
      }
    }

    return new Positioned(
      bottom: 80,
      right: 0,
      child: new ButtonTheme(
        minWidth: 0,
        height: 0,
        child: FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: _click,
          child: new ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), bottomLeft: Radius.circular(50)),
            child: Container(
              width: 60,
              height: 30,
              padding: EdgeInsets.all(3),
              color: Colors.white,
              child: new Row(
                children: <Widget>[
                  SizedBox(
                    width: 2,
                  ),
                  Icon(
                    Icons.format_list_bulleted,
                    size: 20,
                    color: Color(0xFFcea044),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    '明细',
                    style: TextStyle(fontSize: 14, color: Color(0xFFcea044)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
