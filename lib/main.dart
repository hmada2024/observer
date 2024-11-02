import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/weekly_task_schedule.dart';
import 'controllers/task_controller.dart'; // استيراد وحدة التحكم

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
      home: WeeklyTaskSchedule(),
      routes: {
        '/weekly': (context) => WeeklyTaskSchedule(),
      },
    );
  }
}
