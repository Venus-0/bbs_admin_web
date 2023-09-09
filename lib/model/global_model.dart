import 'package:bbs_admin_web/model/admin_user_model.dart';
import 'package:flutter/material.dart';

class GlobalModel extends ChangeNotifier {
  static GlobalKey navigatorKey = GlobalKey();
  static AdminUserModel? user;
}
