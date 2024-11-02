import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/task_controller.dart';
import '../const.dart';

class WeeklyTaskSchedule extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  WeeklyTaskSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime firstDayOfWeek = now.subtract(Duration(days: (now.weekday + 1) % 7));
    List<DateTime> weekDates = List.generate(7, (index) => firstDayOfWeek.add(Duration(days: index)));

    return DefaultTabController(
      length: 2,
      initialIndex: 0, // ضبط الفرائض كقيمة افتراضية
      child: Scaffold(
        appBar: AppBar(
          title: Text('Weekly Task Schedule', textAlign: TextAlign.right),
          bottom: TabBar(
            tabs: [
              Tab(text: 'الفرائض'),
              Tab(text: 'السنن'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildTaskTable(weekDates, prayers, taskController, true),
            buildTaskTable(weekDates, sunnahTasks, taskController, false),
          ],
        ),
      ),
    );
  }

  Widget buildTaskTable(List<DateTime> weekDates, List<String> tasks, TaskController taskController, bool isFard) {
    return Obx(() {
      if (taskController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Table(
            border: TableBorder.all(),
            children: [
              TableRow(
                children: [
                  SizedBox.shrink(),
                  for (var task in tasks)
                    Container(
                      decoration: BoxDecoration(color: Colors.blueAccent),
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          task,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
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
                          return Tooltip(
                            message: isFuture ? "لا يمكن تعديل المهام للمستقبل" : "اضغط لتعديل الحالة",
                            child: Checkbox(
                              value: taskController.isTaskCompleted(isFard, j, i),
                              onChanged: isFuture ? null : (bool? value) {
                                taskController.toggleTaskCompletion(isFard, j, i, value!);
                              },
                              activeColor: isFuture ? Colors.grey : Colors.blue,
                            ),
                          );
                        }),
                      ),
                  ],
                ),
            ],
          ),
        );
      }
    });
  }
}
