import 'package:bbs_admin_web/widget/buttons.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
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
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      hintText: "用户名",
                      hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                      contentPadding: EdgeInsets.zero,
                    ),
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
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      hintText: "用户邮箱",
                      hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                      contentPadding: EdgeInsets.zero,
                    ),
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
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      hintText: "用户密码",
                      hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                      contentPadding: EdgeInsets.zero,
                    ),
                    obscureText: true,
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
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      hintText: "确认密码",
                      hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                      contentPadding: EdgeInsets.zero,
                    ),
                    obscureText: true,
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
                  Buttons.getButton("重置", () {}, fillColor: Color(0xFF3498db), textColor: Colors.white),
                  Buttons.getButton("添加用户", () {}, fillColor: Color(0xFF2ecc71), textColor: Colors.white),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
