import 'package:get/get.dart';
import 'package:observer/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskController extends GetxController {
  var fardTaskCompletionStatus = List.generate(7, (index) => List<bool>.filled(5, false)).obs;
  var sunnahTaskCompletionStatus = List.generate(7, (index) => List<bool>.filled(5, false)).obs;
  var isLoading = true.obs;
  // إضافة قائمة لتخزين حالة المهام 
  RxList<TaskRecord> taskRecords = <TaskRecord>[].obs;
  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  bool isTaskCompleted(bool isFard, int dayIndex, int taskIndex) {
    return isFard
        ? fardTaskCompletionStatus[dayIndex][taskIndex]
        : sunnahTaskCompletionStatus[dayIndex][taskIndex];
  }

  void toggleTaskCompletion(bool isFard, int dayIndex, int taskIndex, bool isCompleted) {
    if (isFard) {
      fardTaskCompletionStatus[dayIndex][taskIndex] = isCompleted;
      fardTaskCompletionStatus.refresh();
    } else {
      sunnahTaskCompletionStatus[dayIndex][taskIndex] = isCompleted;
      sunnahTaskCompletionStatus.refresh();
    }
    saveTasks(isFard);
  }

  bool isDateInFuture(DateTime date) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime comparedDate = DateTime(date.year, date.month, date.day);
    return comparedDate.isAfter(today);
  }

  void saveTasks(bool isFard) async {
  final prefs = await SharedPreferences.getInstance();
  
  // حفظ قائمة taskRecords في SharedPreferences
  prefs.setString('taskRecords', jsonEncode(taskRecords.map((task) => task.toJson()).toList()));
  
  prefs.setString(
    isFard ? 'fardTaskCompletionStatus' : 'sunnahTaskCompletionStatus',
    jsonEncode(isFard ? fardTaskCompletionStatus : sunnahTaskCompletionStatus),
  );
}


  void loadTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final fardStatus = prefs.getString('fardTaskCompletionStatus');
    if (fardStatus != null) {
      fardTaskCompletionStatus.value = List<List<bool>>.from(
        jsonDecode(fardStatus).map((item) => List<bool>.from(item))
      );
    }

    final sunnahStatus = prefs.getString('sunnahTaskCompletionStatus');
    if (sunnahStatus != null) {
      sunnahTaskCompletionStatus.value = List<List<bool>>.from(
        jsonDecode(sunnahStatus).map((item) => List<bool>.from(item))
      );
    }

    isLoading.value = false;
  }

}
