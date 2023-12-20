import 'package:bbs_admin_web/http/api.dart';
import 'package:bbs_admin_web/utils/event_bus.dart';
import 'package:bbs_admin_web/utils/toast.dart';
import 'package:bbs_admin_web/views/home/user_manage_page.dart';
import 'package:bbs_admin_web/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formMap = {};

  void onSave() async {
    final _state = _formKey.currentState;
    if (_state?.validate() ?? false) {
      _state?.save();
      if (_formMap['passwordChk'] != _formMap['password']) {
        Toast.showToast("两次密码不一致");
        return;
      }
      EasyLoading.show();
      bool _ret = await Api.addUser(_formMap['name'], _formMap['email'], _formMap['password'], 0);
      EasyLoading.dismiss();
      if (_ret) {
        eventBus.fire(UserEvent());
        eventBus.fire(PageClass(UserManagePage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16, left: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white, boxShadow: [
        BoxShadow(
          blurRadius: 8,
          color: Color(0xFFD8D8D8),
          blurStyle: BlurStyle.outer,
        )
      ]),
      padding: EdgeInsets.all(12),
      child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "用户信息",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 100, child: Text("用户名:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                    SizedBox(
                      width: 260,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          hintText: "用户名",
                          hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSaved: (newValue) {
                          _formMap['name'] = newValue;
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "用户名不能为空";
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 100, child: Text("用户邮箱:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                    SizedBox(
                      width: 260,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          hintText: "用户邮箱",
                          hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSaved: (newValue) {
                          _formMap['email'] = newValue;
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "用户邮箱不能为空";
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 100, child: Text("用户密码:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                    SizedBox(
                      width: 260,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          hintText: "用户密码",
                          hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                          contentPadding: EdgeInsets.zero,
                        ),
                        obscureText: true,
                        onSaved: (newValue) {
                          _formMap['password'] = newValue;
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "用户密码不能为空";
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 100, child: Text("确认密码:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                    SizedBox(
                      width: 260,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          hintText: "确认密码",
                          hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                          contentPadding: EdgeInsets.zero,
                        ),
                        obscureText: true,
                        onSaved: (newValue) {
                          _formMap['passwordChk'] = newValue;
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "用户密码不能为空";
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 360,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Buttons.getButton("重置", () {
                        _formKey.currentState?.reset();
                      }, fillColor: Color(0xFF3498db), textColor: Colors.white),
                      Buttons.getButton("添加用户", onSave, fillColor: Color(0xFF2ecc71), textColor: Colors.white),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
