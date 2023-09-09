import 'dart:math';

import 'package:action_slider/action_slider.dart';
import 'package:bbs_admin_web/views/home/home_page.dart';
import 'package:bbs_admin_web/http/api.dart';
import 'package:bbs_admin_web/http/http.dart';
import 'package:bbs_admin_web/model/admin_user_model.dart';
import 'package:bbs_admin_web/model/global_model.dart';
import 'package:bbs_admin_web/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _idController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  bool _showPassword = false;

  bool _onBusy = false;

  ActionSliderController _actionSliderController = ActionSliderController();

  ///注册
  Future<void> onLogin() async {
    if (_onBusy) return;
    String _id = _idController.text;
    String _pwd = _pwdController.text;

    if (_id.isEmpty) {
      Toast.showToast("请填写账号");
      return;
    }
    if (_pwd.isEmpty) {
      Toast.showToast("密码不能为空");
      return;
    }

    _onBusy = true;
    EasyLoading.show();
    Map _res = await Api.login(_id, _pwd);
    EasyLoading.dismiss();
    _onBusy = false;
    if (_res['code'] == 200) {
      Toast.showToast("登录成功");
      Map<String, dynamic> _user = _res['result']['user'];
      String _cookie = _res['result']['token'];
      Http.saveCookie(_cookie);
      GlobalModel.user = AdminUserModel.fromJson(_user);
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => HomePage(),
          ),
          (route) => false);
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
    }

    print(_res);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
          body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, -0.2),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(blurRadius: 4.0, color: Color(0xFFD8D8D8), blurStyle: BlurStyle.outer)],
                ),
                width: 300,
                height: 260,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "论坛管理后台",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    TextField(
                      controller: _idController,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
                        hintText: "账号",
                        hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _pwdController,
                      textAlign: TextAlign.center,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
                        hintText: "密码",
                        hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
                alignment: Alignment(0, 0.7),
                child: Container(
                  margin: EdgeInsets.only(bottom: max(0, 100 - MediaQuery.of(context).viewInsets.bottom / 2)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 300,
                        child: ActionSlider.standard(
                          child: Text("登录"),
                          controller: _actionSliderController,
                          action: (controller) async {
                            onLogin();
                          },
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      )),
      onTap: () {
        FocusScope.of(context).unfocus();
      },
    );
  }
}
