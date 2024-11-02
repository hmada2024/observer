import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import '../controllers/task_controller.dart';
import '../const.dart';

class TaskTable extends StatelessWidget {
  final List<DateTime> weekDates;
  final List<String> tasks;
  final bool isFard;
  final TaskController taskController = Get.put(TaskController());

  TaskTable({super.key, required this.weekDates, required this.tasks, required this.isFard});

  @override
  Widget build(BuildContext context) {
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
                            return GestureDetector(
                              onTap: () {
                                if (isFuture) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("لا يمكن تعديل الحالة للمستقبل"),
                                    ),
                                  );
                                } else {
                                  bool isCompleted = !taskController.isTaskCompleted(isFard, j, i);
                                  taskController.toggleTaskCompletion(isFard, j, i, isCompleted);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(isCompleted ? "بارك الله فيك" : "لقد غيرت الحالة"),
                                    ),
                                  );
                                }
                              },
                              child: Checkbox(
                                value: taskController.isTaskCompleted(isFard, j, i),
                                onChanged: isFuture ? null : (bool? value) {
                                  taskController.toggleTaskCompletion(isFard, j, i, value!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(value ? "بارك الله فيك" : "لقد غيرت الحالة"),
                                    ),
                                  );
                                },
                                activeColor: isFuture ? Colors.grey : Colors.blue[800],
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
