import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';

class AnalyticsPage extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, int> analysis = taskController.analyzeTasksCompletion();

    return Scaffold(
      appBar: AppBar(
        title: Text('تحليل الالتزام'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'تحليل مدى التزامك بالمهام المطلوبة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'عدد المهام الكلي: ${analysis["totalTasks"]}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'عدد المهام المنجزة: ${analysis["completedTasks"]}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'نسبة الإنجاز: ${((analysis["completedTasks"]! / analysis["totalTasks"]!) * 100).toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: analysis["completedTasks"]! / analysis["totalTasks"]!,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
              minHeight: 20,
            ),
          ],
        ),
      ),
    );
  }
}
