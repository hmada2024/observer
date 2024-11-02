import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/task_controller.dart';

class WeeklyTaskSchedule extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  WeeklyTaskSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> daysOfWeek = [
      'السبت',
      'الأحد',
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة'
    ];

    List<String> tasks = [
      'الذهاب للجيم',
      'انهاء العمل اليومي',
      'تحويل المال',
      'الذهاب إلى المطعم',
      'قراءة كتاب'
    ];

    DateTime now = DateTime.now();
    DateTime firstDayOfWeek = now.subtract(Duration(days: (now.weekday + 1) % 7));
    List<DateTime> weekDates = List.generate(7, (index) => firstDayOfWeek.add(Duration(days: index)));

    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Task Schedule', textAlign: TextAlign.right),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          border: TableBorder.all(),
          children: [
            // رؤوس الصفوف (المهام)
            TableRow(
              children: [
                SizedBox.shrink(),
                for (var task in tasks)
                  Center(
                    child: Text(
                      task,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
              ],
            ),
            // الصفوف العمودية للأيام والتشيك بوكس
            for (int j = 0; j < 7; j++)
              TableRow(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(daysOfWeek[j], textAlign: TextAlign.right),
                        Text(DateFormat('dd/MM').format(weekDates[j]), textAlign: TextAlign.right),
                      ],
                    ),
                  ),
                  for (int i = 0; i < tasks.length; i++)
                    Center(
                      child: Obx(() {
                        bool isFuture = taskController.isDateInFuture(weekDates[j]);
                        return Checkbox(
                          value: taskController.isTaskCompleted(j, i),
                          onChanged: isFuture ? null : (bool? value) {
                            taskController.toggleTaskCompletion(j, i, value!);
                          },
                          activeColor: isFuture ? Colors.grey : Colors.blue, // تغيير لون المربع
                        );
                      }),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
