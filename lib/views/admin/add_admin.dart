import 'package:bbs_admin_web/http/api.dart';
import 'package:bbs_admin_web/utils/toast.dart';
import 'package:bbs_admin_web/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddAdmin extends StatefulWidget {
  const AddAdmin({super.key, required this.onAdd});

  static void showAddAdmin(BuildContext context, VoidCallback onAdd) {
    showDialog(context: context, builder: (context) => AddAdmin(onAdd: onAdd));
  }

  final VoidCallback onAdd;

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordChkController = TextEditingController();

  void onAdd() async {
    String _name = _nameController.text;
    String _password = _passwordController.text;
    String _passwordChk = _passwordChkController.text;

    if (_name.isEmpty) {
      Toast.showToast("管理员名称不能为空");
      return;
    }
    if (_password.isEmpty) {
      Toast.showToast("密码不能为空");
      return;
    }
    if (_passwordChk.isEmpty) {
      Toast.showToast("请再输入一次密码");
      return;
    }
    if (_password != _passwordChk) {
      Toast.showToast("两次密码不一致");
      return;
    }
    EasyLoading.show();
    bool _ret = await Api.addAdminUser(_name, _password);
    EasyLoading.dismiss();
    if (_ret) {
      widget.onAdd();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        width: 330,
        height: 280,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
        child: Column(
          children: [
            Text(
              "添加管理员",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Row(
              children: [
                SizedBox(width: 120, child: Text("管理员名称:")),
                Expanded(
                    child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          hintText: "管理员名称",
                          hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                          contentPadding: EdgeInsets.zero,
                        ),
                        controller: _nameController)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 120, child: Text("密码:")),
                Expanded(
                    child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    hintText: "密码",
                    hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                    contentPadding: EdgeInsets.zero,
                  ),
                  controller: _passwordController,
                  obscureText: true,
                )),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 120, child: Text("在输入一次密码:")),
                Expanded(
                    child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    hintText: "在输入一次密码",
                    hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                    contentPadding: EdgeInsets.zero,
                  ),
                  controller: _passwordChkController,
                  obscureText: true,
                )),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Buttons.getButton("重置", () {
                  setState(() {
                    _nameController.clear();
                    _passwordController.clear();
                    _passwordChkController.clear();
                  });
                }, fillColor: Color(0xFF3498db), textColor: Colors.white),
                SizedBox(width: 30),
                Buttons.getButton("确定", onAdd, fillColor: Color(0xFF2ecc71), textColor: Colors.white),
              ],
            )
          ],
        ),
      ),
    );
  }
}
