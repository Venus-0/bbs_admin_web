import 'package:bbs_admin_web/model/global_model.dart';
import 'package:bbs_admin_web/views/boot/boot_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => GlobalModel(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'bbs',
      builder: (context, widget) {
        final botToastBuilder = BotToastInit(); //1.调用BotToastInit
        final easyLoadingBuilder = EasyLoading.init();
        Widget child = easyLoadingBuilder(context, MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: widget!));
        child = botToastBuilder(context, child);
        return child;
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BootPage(),
    );
  }
}
