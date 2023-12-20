import 'package:bbs_admin_web/http/api.dart';
import 'package:bbs_admin_web/model/admin_user_model.dart';
import 'package:bbs_admin_web/utils/event_bus.dart';
import 'package:bbs_admin_web/utils/toast.dart';
import 'package:bbs_admin_web/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class AdminUserDetail extends StatefulWidget {
  AdminUserDetail({super.key, required this.adminUser});
  AdminUserModel adminUser;
  @override
  State<AdminUserDetail> createState() => _AdminUserDetailState();
}

class _AdminUserDetailState extends State<AdminUserDetail> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _modifyMap = {};
  late Map<String, dynamic> _jsonData;

  TextEditingController _resetPwdController = TextEditingController();
  TextEditingController _resetPwdChkController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _jsonData = widget.adminUser.toJson();
  }

  void _resetPassword() async {
    String _pwd = _resetPwdController.text;
    String _pwdChk = _resetPwdChkController.text;
    if (_pwd != _pwdChk) {
      Toast.showToast("两次密码不一致，请重新输入");
      return;
    }
  }

  void _onSave() async {
    final _state = _formKey.currentState;
    if (_state?.validate() ?? false) {
      _state?.save();
      if (_modifyMap.isEmpty) return;
      EasyLoading.show();
      bool _ret = await Api.modifyAdminUser(widget.adminUser.admin_id, _modifyMap);
      EasyLoading.dismiss();
      if (_ret) {
        _modifyMap.forEach((key, value) {
          _jsonData[key] = value;
        });
        AdminUserModel _adminUser = AdminUserModel.fromJson(_jsonData);
        widget.adminUser = _adminUser;
        eventBus.fire(AdminUser(_adminUser));
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
                      Row(
                        children: [
                          SizedBox(width: 120, child: Text("管理员名称:")),
                          Expanded(
                            child: TextFormField(
                              initialValue: widget.adminUser.name,
                              onSaved: (newValue) {
                                if (newValue?.isEmpty ?? true) return;
                                if (newValue != widget.adminUser.name) {
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
                              child: DropdownButtonFormField(
                            value: _modifyMap['rank'] ?? widget.adminUser.rank,
                            items: [
                              DropdownMenuItem(
                                child: Text("普通管理员"),
                                value: 0,
                              ),
                              DropdownMenuItem(
                                child: Text("超级管理员"),
                                value: 1,
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                if (value == widget.adminUser.rank && _modifyMap['rank'] != null) {
                                  _modifyMap.remove('rank');
                                } else if (value != widget.adminUser.rank) {
                                  _modifyMap['rank'] = value;
                                }
                              });
                            },
                          ))
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 120, child: Text("状态:")),
                          Expanded(
                              child: DropdownButtonFormField(
                            value: _jsonData['delete_time'] == null,
                            items: [
                              DropdownMenuItem(
                                child: Text("正常"),
                                value: true,
                              ),
                              DropdownMenuItem(
                                child: Text("已删除"),
                                value: false,
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  _modifyMap.remove("delete_time");
                                  _jsonData.remove('delete_time');
                                } else {
                                  late DateTime _time;
                                  if (widget.adminUser.delete_time == null) {
                                    _time = DateTime.now();
                                  } else {
                                    _time = widget.adminUser.delete_time!;
                                  }
                                  _jsonData['delete_time'] = DateFormat("yyyy-MM-dd HH:mm:ss").format(_time);
                                  _modifyMap['delete_time'] = DateFormat("yyyy-MM-dd HH:mm:ss").format(_time);
                                }
                              });
                            },
                          ))
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Buttons.getButton("保存", _onSave, fillColor: Color(0xFF2ecc71), textColor: Colors.white),
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
                      Text("密码重置", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          SizedBox(width: 120, child: Text("新密码:")),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(hintText: "请输入新密码"),
                              controller: _resetPwdController,
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
                              decoration: InputDecoration(hintText: "请再输入一次新密码"),
                              controller: _resetPwdChkController,
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
                              _resetPwdChkController.clear();
                              _resetPwdController.clear();
                            });
                          }, fillColor: Color(0xFF3498db), textColor: Colors.white),
                          SizedBox(width: 30),
                          Buttons.getButton("确定", _resetPassword, fillColor: Color(0xFF2ecc71), textColor: Colors.white),
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
