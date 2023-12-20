import 'dart:html';

import 'package:bbs_admin_web/views/home/home_page.dart';
import 'package:bbs_admin_web/http/api.dart';
import 'package:bbs_admin_web/views/login/login_page.dart';
import 'package:bbs_admin_web/model/admin_user_model.dart';
import 'package:bbs_admin_web/model/global_model.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BootPage extends StatefulWidget {
  const BootPage({super.key});

  @override
  State<BootPage> createState() => _BootPageState();
}

class _BootPageState extends State<BootPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    await Future.delayed(Duration(milliseconds: 1000));
    String _cookie = document.cookie ?? "";
    if (_cookie.isEmpty) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
          (route) => false);
    } else {
      Map _res = await Api.checkLogin();
      if (_res['code'] == 200) {
        GlobalModel.user = AdminUserModel.fromJson(_res['result']['user']);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
            (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.hexagonDots(color: Colors.deepPurple, size: 48),
    );
  }
}
