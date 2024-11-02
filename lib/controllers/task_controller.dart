import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskController extends GetxController {
  var taskCompletionStatus = List.generate(7, (index) => List<bool>.filled(5, false)).obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  bool isTaskCompleted(int dayIndex, int taskIndex) {
    return taskCompletionStatus[dayIndex][taskIndex];
  }

  void toggleTaskCompletion(int dayIndex, int taskIndex, bool isCompleted) {
    taskCompletionStatus[dayIndex][taskIndex] = isCompleted;
    taskCompletionStatus.refresh();
    saveTasks();
  }

  bool isDateInFuture(DateTime date) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime comparedDate = DateTime(date.year, date.month, date.day);
    return comparedDate.isAfter(today);
  }

  void saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('taskCompletionStatus', jsonEncode(taskCompletionStatus));
  }

  void loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final status = prefs.getString('taskCompletionStatus');
    if (status != null) {
      taskCompletionStatus.value = List<List<bool>>.from(
        jsonDecode(status).map((item) => List<bool>.from(item))
      );
    }
    isLoading.value = false;
  }
}
