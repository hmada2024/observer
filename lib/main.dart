import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/home_page.dart';
import 'controllers/task_controller.dart'; 

void main() {
  runApp(ObserverApp());
}

class ObserverApp extends StatelessWidget {
  const ObserverApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TaskController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'المراقب',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/weekly': (context) => HomePage(),
      },
    );
  }
}
