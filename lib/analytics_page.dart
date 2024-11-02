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
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            AnimatedContainer(
              duration: Duration(seconds: 1),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 255, 255, 0.1), // استخدام Color.fromRGBO لضبط الشفافية
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'عدد المهام الكلي: ${analysis["totalTasks"]}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  Text(
                    'عدد المهام المنجزة: ${analysis["completedTasks"]}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'نسبة الإنجاز: ${((analysis["completedTasks"]! / analysis["totalTasks"]!) * 100).toStringAsFixed(2)}%',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            AnimatedContainer(
              duration: Duration(seconds: 1),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 255, 0.1), 
                borderRadius: BorderRadius.circular(10),
              ),
              child: LinearProgressIndicator(
                value: analysis["completedTasks"]! / analysis["totalTasks"]!,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
