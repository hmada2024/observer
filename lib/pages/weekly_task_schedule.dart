import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
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
      initialIndex: 0,
      child: Directionality(
        textDirection: TextDirection.rtl, 
        child: Scaffold(
          appBar: AppBar(
            title: Align(
              alignment: Alignment.center,
              child: Text('الجدول الأسبوعي'),
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: 'الفرائض'),
                Tab(text: 'السنن'),
              ],
              indicatorColor: const Color.fromARGB(255, 7, 28, 148),
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              unselectedLabelColor: const Color.fromARGB(179, 6, 46, 14),
              labelColor: const Color.fromARGB(255, 7, 28, 148),
            ),
          ),
          body: TabBarView(
            children: [
              buildTaskTable(weekDates, prayers, taskController, true),
              buildTaskTable(weekDates, sunnahTasks, taskController, false),
            ],
          ),
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
            border: TableBorder.all(
              color: const Color.fromARGB(255, 71, 6, 28), 
              width: 2.0, 
            ),
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
                          style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)),
                          textAlign: TextAlign.center, 
                        ),
                      ),
                    ),
                ],
              ),
              for (int j = 0; j < 7; j++)
                TableRow(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.green), 
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          children: [
                            Text(daysOfWeek[j], textAlign: TextAlign.center), 
                            Text(intl.DateFormat('dd/MM').format(weekDates[j]), textAlign: TextAlign.center), 
                          ],
                        ),
                      ),
                    ),
                    for (int i = 0; i < tasks.length; i++)
                      Container(
                        decoration: BoxDecoration(color: Colors.white), 
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Obx(() {
                            bool isFuture = taskController.isDateInFuture(weekDates[j]);
                            return Tooltip(
                              message: isFuture ? "لا يمكن تعديل الحالة للمستقبل" : "اضغط لتعديل الحالة",
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
