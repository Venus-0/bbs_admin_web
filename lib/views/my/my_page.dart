import 'package:bbs_admin_web/http/api.dart';
import 'package:bbs_admin_web/http/http.dart';
import 'package:bbs_admin_web/model/admin_user_model.dart';
import 'package:bbs_admin_web/model/global_model.dart';
import 'package:bbs_admin_web/utils/toast.dart';
import 'package:bbs_admin_web/views/login/login_page.dart';
import 'package:bbs_admin_web/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _modifyMap = {};
  late Map<String, dynamic> _jsonData;

  TextEditingController _oldPwdController = TextEditingController();
  TextEditingController _newPwdController = TextEditingController();
  TextEditingController _newPwdChkController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _jsonData = GlobalModel.user!.toJson();
  }

  void _editPassword() async {
    String _oldPwd = _oldPwdController.text;
    String _newPwd = _newPwdController.text;
    String _newPwdChk = _newPwdChkController.text;
    if (_oldPwd.isEmpty) {
      Toast.showToast("旧密码不能为空");
      return;
    }
    if (_newPwd.isEmpty) {
      Toast.showToast("新密码不能为空");
      return;
    }
    if (_newPwdChk.isEmpty) {
      Toast.showToast("请再输入一次新密码");
      return;
    }
    if (_oldPwd == _newPwd) {
      Toast.showToast("新旧密码不能一致");
      return;
    }
    if (_newPwd != _newPwdChk) {
      Toast.showToast("两次密码不一致，请重新输入");
      return;
    }
    bool _ret = await Api.modifyPassword(_oldPwd, _newPwd);
    if (_ret) {
      Toast.showToast("修改成功,请重新登录");
      Http.removeCookie();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
    }
  }

  void _onSave() async {
    final _state = _formKey.currentState;
    if (_state?.validate() ?? false) {
      _state?.save();
      if (_modifyMap.isEmpty) return;
      EasyLoading.show();
      bool _ret = await Api.modifyAdminUser(GlobalModel.user!.admin_id, _modifyMap);
      EasyLoading.dismiss();
      if (_ret) {
        _modifyMap.forEach((key, value) {
          _jsonData[key] = value;
        });
        AdminUserModel _adminUser = AdminUserModel.fromJson(_jsonData);
        GlobalModel.user = _adminUser;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String? formatDate(DateTime? date) {
      if (date == null) return null;
      return DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    }

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                    child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text("信息编辑", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 120, child: Text("管理员名称:")),
                          Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                hintText: "管理员名称",
                                hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                                contentPadding: EdgeInsets.zero,
                              ),
                              initialValue: GlobalModel.user!.name,
                              onSaved: (newValue) {
                                if (newValue?.isEmpty ?? true) return;
                                if (newValue != GlobalModel.user!.name) {
                                  _modifyMap['name'] = newValue;
                                }
                              },
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return "不能为空";
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
                          SizedBox(width: 120, child: Text("权限:")),
                          Expanded(
                              child: TextFormField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.transparent)),
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(color: Colors.grey),
                            initialValue: GlobalModel.user!.rank == 1 ? "超级管理员" : "普通管理员",
                            readOnly: true,
                          ))
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 120, child: Text("状态:")),
                          Expanded(
                              child: TextFormField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.transparent)),
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(color: Colors.grey),
                            initialValue: GlobalModel.user!.delete_time == null ? "正常" : "已删除",
                            readOnly: true,
                          ))
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 120, child: Text("创建时间:")),
                          Expanded(
                              child: TextFormField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.transparent)),
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(color: Colors.grey),
                            initialValue: formatDate(GlobalModel.user!.create_time) ?? "--",
                            readOnly: true,
                          ))
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 120, child: Text("最后一次登录时间:")),
                          Expanded(
                              child: TextFormField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.transparent)),
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(color: Colors.grey),
                            initialValue: formatDate(GlobalModel.user!.login_time) ?? "--",
                            readOnly: true,
                          ))
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Buttons.getButton("保存", _onSave, fillColor: Color(0xFF2ecc71), textColor: Colors.white),
                          SizedBox(width: 30),
                          Buttons.getButton("退出登录", () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text("提示"),
                                content: Text("是否退出?"),
                                actions: [
                                  Buttons.getButton("是", () {
                                    Http.removeCookie();
                                    Navigator.pushAndRemoveUntil(
                                        context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
                                  }, textColor: Color(0xFFe74c3c)),
                                  Buttons.getButton("否", () {
                                    Navigator.pop(context);
                                  }),
                                ],
                              ),
                            );
                          }, fillColor: Color(0xFFe74c3c), textColor: Colors.white),
                        ],
                      )
                    ],
                  ),
                )),
              ),
            ),
            VerticalDivider(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text("修改密码", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 120, child: Text("旧密码:")),
                          Expanded(
                            child: TextField(
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                hintText: "请输入旧密码",
                                hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                                contentPadding: EdgeInsets.zero,
                              ),
                              controller: _oldPwdController,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 120, child: Text("新密码:")),
                          Expanded(
                            child: TextField(
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                hintText: "请输入新密码",
                                hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                                contentPadding: EdgeInsets.zero,
                              ),
                              controller: _newPwdController,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 120, child: Text("再输入一次新密码:")),
                          Expanded(
                            child: TextField(
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                hintText: "请再输入一次新密码",
                                hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                                contentPadding: EdgeInsets.zero,
                              ),
                              controller: _newPwdChkController,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Buttons.getButton("重置", () {
                            setState(() {
                              _oldPwdController.clear();
                              _newPwdController.clear();
                              _newPwdChkController.clear();
                            });
                          }, fillColor: Color(0xFF3498db), textColor: Colors.white),
                          SizedBox(width: 30),
                          Buttons.getButton("确定", _editPassword, fillColor: Color(0xFF2ecc71), textColor: Colors.white),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
