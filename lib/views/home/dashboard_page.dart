import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/work_inprogress.png",width: 300),
          Text(
            "开发中...",
            style: TextStyle(color: Color(0xFFD8D8D8),fontSize: 22),
          )
        ],
      ),
    );
  }
}
